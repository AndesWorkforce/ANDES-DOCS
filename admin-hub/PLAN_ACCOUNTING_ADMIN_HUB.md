# PLAN: Accounting / Admin Hub - Migración y Desarrollo

## Estado Actual del Sistema

### Lo que YA existe:
| Componente | Estado | Ubicación |
|---|---|---|
| `ProcesoContratacion` (Contrato) | ✅ Existe | `schema.prisma` - incluye `ofertaSalarial`, `monedaSalario` |
| `DiscretionaryBonusType` enum | ✅ Existe | `NONE`, `HALF_MONTH_ONCE_DECEMBER`, `FULL_MONTH_ONCE_DECEMBER`, `FULL_MONTH_TWICE_JUNE_DECEMBER` |
| `paidHolidays` flag en contrato | ✅ Existe | boolean en `ProcesoContratacion` |
| `EvaluacionPagoMensual` | ✅ Existe | Evaluación mensual por contrato (doc proof + habilitación) |
| `PaymentInbox` (Invoice contratista) | ✅ Existe | Invoice básico con amount, invoiceNumber, dataJson |
| `Holiday` model (festivos por país) | ✅ Existe | día, mes, país, codigoPais |
| Admin consolidated payments view | ✅ Existe | `obtenerPagosMensualesConsolidados()` |
| Actualización bonus/holidays por contrato | ✅ Existe | `actualizarBonusYPaidHolidays()` |

### Lo que NO existe (hay que construir):
- Client Price calculation
- Local Holiday payment calculation con rates por país
- Overtime tracking y cálculos
- Unpaid Leave con Customer Credit
- Customer Credits / Customer Charges
- IPB Bonus con acumulación
- Holiday Bonus cálculo y pago
- Income Variables (positivo/negativo)
- Referral Bonus system
- Birthday Bonus
- Anniversary Pay Adjustment
- Seniority Bonus
- Bloqueo de fechas (invoice 8-12, payroll hasta 25)
- Part-time rules BK
- Migración masiva desde Power App

---

## PLAN DE DESARROLLO POR FASES

### FASE 0: Migración de datos desde Power App
**Estimación: 1-2 semanas**

| Tarea | Detalle | Días |
|---|---|---|
| Definir formato Excel de migración | Columnas: email personal (identificador), basic pay, client price, holiday bonus type, IPB, fecha inicio, etc. | 1 |
| Script de lectura/validación del Excel | Validar emails, match con contratos existentes, reportar inconsistencias | 2 |
| Script de migración | Asociar datos Excel → `ProcesoContratacion` existente, crear registros nuevos | 2 |
| Migración de prueba en test | Ejecutar, validar, corregir | 2 |
| Migración en producción | Ejecutar con backup previo | 1 |

**Impacto en migración:** Similar a la migración inicial de contratos. Se necesita:
1. Excel con email personal como key
2. Match email → `Usuario.correo` → `Postulacion` → `ProcesoContratacion`
3. Nuevos campos del schema se llenan con los datos migrados

---

### FASE 1: Schema / Modelos de Base de Datos
**Estimación: 3-4 días**

#### Nuevos modelos y campos en Prisma:

```prisma
// ═══ Campos nuevos en ProcesoContratacion ═══
model ProcesoContratacion {
  // ... campos existentes ...
  
  // Basic Pay ya existe como ofertaSalarial
  clientPrice            Decimal?   // Precio al cliente (calculado o manual)
  clientPriceFormula     String?    // Referencia a la fórmula usada
  
  // Holiday Bonus config (ya existe discretionaryBonusType)
  
  // IPB
  ipbEnabled             Boolean    @default(true)  // N/A option
  
  // Local Holidays
  localHolidayEnabled    Boolean    @default(true)  // N/A option
  localHolidayRate       Decimal?   // x1.5, x2, x3 según país
  
  // Referral info
  referredById           String?    // ID del contratista que lo refirió
  referralBonusPaid      Boolean    @default(false)
  referralBonusPaidDate  DateTime?
  
  // Anniversary
  anniversaryDate        DateTime?  // Fecha de aniversario (fecha inicio labores)
  lastAnniversaryRaise   DateTime?  // Último aumento aplicado
  
  // Seniority
  seniorityBonusActive   Boolean    @default(false)
  seniorityBonusStartDate DateTime?
  
  // Birthday bonus exclusion
  birthdayBonusExcluded  Boolean    @default(false) // Para Hill & Ponton, WHG, Jelks
  
  // Part-time
  isPartTime             Boolean    @default(false)
  partTimePercentage     Decimal?   // e.g. 0.5 para 50%
  
  // Relaciones nuevas
  monthlyItems           MonthlyPayrollItem[]
  customerCredits        CustomerCredit[]
  customerCharges        CustomerCharge[]
}

// ═══ NUEVO: Items de nómina mensual ═══
model MonthlyPayrollItem {
  id                    String              @id @default(uuid())
  procesoContratacionId String
  yearMonth             String              // "2026-04"
  type                  PayrollItemType
  description           String?
  amount                Decimal
  rate                  Decimal?            // Para overtime: x1, x1.5, x2
  quantity              Decimal?            // Horas OT, días UL, etc.
  category              String?             // Para Income Variables: Bonus, Reimbursement, Other, Invoice Expense
  notes                 String?
  affectsPayroll        Boolean             @default(true)
  affectsInvoice        Boolean             @default(false)
  createdAt             DateTime            @default(now())
  updatedAt             DateTime            @updatedAt
  createdById           String?
  
  procesoContratacion   ProcesoContratacion @relation(fields: [procesoContratacionId], references: [id], onDelete: Cascade)
  
  @@index([procesoContratacionId, yearMonth])
  @@index([type])
}

enum PayrollItemType {
  LOCAL_HOLIDAY        // Festivo local pagado
  OVERTIME             // Horas extra
  UNPAID_LEAVE         // Ausencia no pagada (negativo)
  IPB_ACCRUAL          // Acumulación IPB mensual
  IPB_PAYOUT           // Pago IPB (Junio/Diciembre)
  HOLIDAY_BONUS        // Bono vacacional (Diciembre)
  INCOME_VARIABLE      // Variable positiva o negativa
  REFERRAL_BONUS       // Bono por referido
  BIRTHDAY_BONUS       // Bono cumpleaños
  ANNIVERSARY_RAISE    // Registro de aumento aniversario
  SENIORITY_BONUS      // Bono antigüedad (>2 años)
  CUSTOMER_CREDIT_DEDUCTION // Deducción que también va al invoice
}

// ═══ NUEVO: Créditos al cliente ═══
model CustomerCredit {
  id                    String              @id @default(uuid())
  procesoContratacionId String
  yearMonth             String
  amount                Decimal             // Positivo = crédito al cliente
  description           String
  reason                String?
  createdAt             DateTime            @default(now())
  createdById           String?
  
  procesoContratacion   ProcesoContratacion @relation(fields: [procesoContratacionId], references: [id], onDelete: Cascade)
  
  @@index([procesoContratacionId, yearMonth])
}

// ═══ NUEVO: Cargos al cliente ═══
model CustomerCharge {
  id                    String              @id @default(uuid())
  procesoContratacionId String
  yearMonth             String
  amount                Decimal
  description           String
  reason                String?
  createdAt             DateTime            @default(now())
  createdById           String?
  
  procesoContratacion   ProcesoContratacion @relation(fields: [procesoContratacionId], references: [id], onDelete: Cascade)
  
  @@index([procesoContratacionId, yearMonth])
}

// ═══ NUEVO: Configuración de tasas por país ═══
model CountryPayrollConfig {
  id                    String   @id @default(uuid())
  countryCode           String   @unique
  countryName           String
  localHolidayRate      Decimal  @default(1.5)  // x1.5 por defecto
  overtimeWeekdayRate   Decimal  @default(1.0)  // Tarifa OT día de semana
  overtimeSaturdayRate  Decimal  @default(1.5)  // Tarifa OT sábado
  overtimeSundayRate    Decimal  @default(1.5)  // Tarifa OT domingo
  workingDaysPerMonth   Int      @default(20)
  createdAt             DateTime @default(now())
  updatedAt             DateTime @updatedAt
}

// ═══ NUEVO: Ajustes de aniversario pendientes ═══
model AnniversaryAdjustment {
  id                    String              @id @default(uuid())
  procesoContratacionId String
  effectiveMonth        String              // "2026-04"
  currentBasicPay       Decimal
  proposedBasicPay      Decimal
  currentClientPrice    Decimal?
  proposedClientPrice   Decimal?
  raisePercentage       Decimal             @default(5.0)
  status                AdjustmentStatus    @default(PENDING)
  approvedById          String?
  approvedAt            DateTime?
  notes                 String?
  createdAt             DateTime            @default(now())
  
  procesoContratacion   ProcesoContratacion @relation(fields: [procesoContratacionId], references: [id])
  
  @@unique([procesoContratacionId, effectiveMonth])
  @@index([effectiveMonth, status])
}

enum AdjustmentStatus {
  PENDING
  APPROVED
  ADJUSTED   // Aprobado con modificación
  REJECTED
}
```

---

### FASE 2: Backend - Módulo de Payroll/Accounting
**Estimación: 3-4 semanas**

#### 2.1 Servicio de cálculos core (5 días)
| Funcionalidad | Fórmula/Lógica | Prioridad |
|---|---|---|
| **Basic Pay** | Viene de `ofertaSalarial` del contrato | Alta |
| **Client Price** | Fórmula de Violeta/Male basada en basic pay | Alta |
| **Daily Rate** | `basicPay / 20` | Alta |
| **Local Holiday Pay** | `dailyRate * rate * numHolidays` (solo L-V, no US holidays, no fines de semana) | Alta |
| **Overtime** | `(basicPay / 20) * horas * tarifaOT` | Alta |
| **Unpaid Leave** | `(basicPay / 20) * días * -1` (excluir fines de semana y festivos) | Alta |

#### 2.2 Bonos y ajustes (5 días)
| Funcionalidad | Fórmula/Lógica | Prioridad |
|---|---|---|
| **IPB Accrual** | `(basicPay / 20) * 6 / 6` = `basicPay / 20` mensual, pago en Jun/Dic | Alta |
| **Holiday Bonus** | Half month / Full month / Full month x2 - pago en Diciembre | Alta |
| **Birthday Bonus** | $50 en mes de cumpleaños (excluir Hill & Ponton, WHG, Jelks) | Media |
| **Referral Bonus** | $100 después de 90 días del referido | Media |
| **Anniversary Raise** | +5% basic pay + client price, reporte mensual anticipado | Alta |
| **Seniority Bonus** | 25% basic pay / 12, mensual después de 2 años | Media |
| **Income Variables** | Positivo/negativo con categoría y notas | Alta |

#### 2.3 Customer Credits/Charges (3 días)
| Funcionalidad | Detalle |
|---|---|
| CRUD Customer Credits | Crear, listar, eliminar créditos por contrato/mes |
| CRUD Customer Charges | Crear, listar, eliminar cargos por contrato/mes |
| Integración con Invoice | Credits y Charges reflejados en el invoice del cliente |

#### 2.4 Bloqueos y reglas de negocio (2 días)
| Funcionalidad | Detalle |
|---|---|
| Bloqueo invoice 8-12 | Solo permitir registrar invoices del día 8 al 12 de cada mes |
| Bloqueo payroll hasta 25 | Payroll no se puede cerrar/aprobar hasta el 25 |
| Reglas part-time BK | Investigar y aplicar reglas específicas |

#### 2.5 Cron jobs y automatizaciones (3 días)
| Job | Frecuencia | Detalle |
|---|---|---|
| IPB Accrual mensual | 1/mes | Crear MonthlyPayrollItem de acumulación |
| Birthday Bonus check | 1/mes | Verificar cumpleaños del mes, crear bonus |
| Anniversary report | 1/mes | Generar lista de aniversarios del mes siguiente |
| Seniority activation | 1/mes | Verificar contratos >2 años, activar bono |
| Referral 90-day check | Diario | Verificar referidos que cumplan 90 días |

#### 2.6 Endpoints API (3 días)
```
POST   /admin/payroll/:contractId/items          → Agregar item de nómina
GET    /admin/payroll/:contractId/summary/:month  → Resumen de nómina de un contrato
GET    /admin/payroll/consolidated/:month         → Vista consolidada de todos
PATCH  /admin/payroll/items/:id                   → Editar item
DELETE /admin/payroll/items/:id                   → Eliminar item

POST   /admin/customer-credits                    → Crear crédito
GET    /admin/customer-credits/:contractId/:month → Listar créditos
POST   /admin/customer-charges                    → Crear cargo
GET    /admin/customer-charges/:contractId/:month → Listar cargos

GET    /admin/anniversary-adjustments/:month      → Lista de aniversarios del mes
PATCH  /admin/anniversary-adjustments/:id         → Aprobar/rechazar/ajustar

GET    /admin/payroll/payslip/:contractId/:month  → Desprendible de pago
GET    /admin/invoice/:contractId/:month          → Invoice del cliente

POST   /admin/payroll/lock/:month                 → Bloquear payroll del mes
GET    /admin/payroll/config/country/:code        → Config de tasas por país
PUT    /admin/payroll/config/country/:code        → Actualizar config país
```

---

### FASE 3: Frontend - Admin Hub
**Estimación: 3-4 semanas**

#### 3.1 Dashboard principal de Accounting (3 días)
- Vista consolidada mensual con todos los contratistas
- Filtros por empresa, país, estado
- Selector de periodo (año-mes)
- Indicadores: total payroll, total invoices, pendientes

#### 3.2 Vista detallada por contratista (5 días)
- **Payroll Tab:**
  - Basic Pay (del contrato)
  - Client Price (calculado)
  - Local Holidays (agregar/ver)
  - Overtime (agregar horas + tarifa)
  - Unpaid Leave (agregar días)
  - IPB (ver acumulado + historial)
  - Holiday Bonus (ver categoría + monto)
  - Income Variables (agregar +/-)
  - Birthday Bonus (automático)
  - Referral Bonus (automático)
  - Seniority Bonus (automático)
  - **Total Payroll calculado**

- **Invoice Tab (Cliente):**
  - Basic Pay → Client Price
  - Customer Credits (CRUD)
  - Customer Charges (CRUD)
  - Unpaid Leave deduction
  - **Total Invoice calculado**

#### 3.3 Desprendible de Pago (Pay Stub) (3 días)
- Vista para el contratista de su desprendible mensual
- Desglose de todos los conceptos
- IPB acumulado visible
- Exportable a PDF

#### 3.4 Reporte de Aniversarios (2 días)
- Lista de aniversarios del mes siguiente
- Basic Pay actual → Proposed (+5%)
- Client Price actual → Proposed
- Botones: Aprobar / Ajustar / Rechazar

#### 3.5 Configuración por país (2 días)
- CRUD de tasas de overtime
- CRUD de tasas de holidays
- Días laborales por mes

#### 3.6 Selector de referido en postulación (2 días)
- Dropdown en formulario de candidato
- Lista de contratistas activos de Andes
- Campo "¿Fue referido por alguien?"

---

### FASE 4: Testing e Integración
**Estimación: 1-2 semanas**

| Tarea | Días |
|---|---|
| Unit tests de cálculos (fórmulas) | 3 |
| Integration tests (API endpoints) | 2 |
| E2E tests flujos completos | 2 |
| UAT con equipo de Violeta/Male | 3 |

---

## RESUMEN DE ESTIMACIÓN

| Fase | Descripción | Estimación |
|---|---|---|
| **Fase 0** | Migración de datos Power App | 1-2 semanas |
| **Fase 1** | Schema / Modelos BD | 3-4 días |
| **Fase 2** | Backend - Módulo Payroll | 3-4 semanas |
| **Fase 3** | Frontend - Admin Hub | 3-4 semanas |
| **Fase 4** | Testing e Integración | 1-2 semanas |
| | | |
| **TOTAL** | | **~10-14 semanas** (2.5-3.5 meses) |

### Con un desarrollador dedicado: ~3 meses
### Con dos desarrolladores en paralelo (API + Client): ~2 meses

---

## IMPACTO EN LA MIGRACIÓN

### Cambios que DEBEN existir antes de migrar:
1. **Nuevos campos en `ProcesoContratacion`**: `clientPrice`, `localHolidayRate`, `ipbEnabled`, `birthdayBonusExcluded`, `isPartTime`, etc.
2. **Nuevos modelos**: `MonthlyPayrollItem`, `CustomerCredit`, `CustomerCharge`, `CountryPayrollConfig`, `AnniversaryAdjustment`
3. **El `DiscretionaryBonusType` enum ya existe** — no necesita cambios

### Orden de migración recomendado:
1. **Primero**: Ejecutar Prisma migration con nuevos campos/modelos (Fase 1)
2. **Segundo**: Migrar datos de Power App a los nuevos campos (Fase 0)
3. **Tercero**: Desarrollar backend + frontend (Fases 2-3)

### Datos que vienen del Excel de migración:
| Campo Excel | → Campo en BD |
|---|---|
| Email personal | → match con `Usuario.correo` → `ProcesoContratacion` |
| Basic Pay | → ya existe como `ofertaSalarial` (validar) |
| Client Price | → nuevo campo `clientPrice` |
| Holiday Bonus Type | → ya existe `discretionaryBonusType` |
| Paid Holidays | → ya existe `paidHolidays` |
| IPB Enabled | → nuevo `ipbEnabled` |
| Local Holiday Rate | → nuevo `localHolidayRate` |
| Birthday Excluded | → nuevo `birthdayBonusExcluded` |
| Part Time % | → nuevos `isPartTime` + `partTimePercentage` |
| Referido por | → nuevo `referredById` |
| Fecha inicio | → ya existe `fechaInicioLabores` |

---

## PRIORIZACIÓN SUGERIDA (MVP)

### Sprint 1 (Semanas 1-2): Schema + Migración
- Fase 1 completa
- Fase 0: Preparar script de migración

### Sprint 2 (Semanas 3-4): Core Calculations
- Basic Pay, Client Price, Daily Rate
- Overtime
- Unpaid Leave
- Income Variables
- Bloqueos de fecha

### Sprint 3 (Semanas 5-6): Bonos Automáticos
- IPB Bonus (acumulación + pago)
- Holiday Bonus
- Birthday Bonus
- Cron jobs

### Sprint 4 (Semanas 7-8): Customer + Referrals
- Customer Credits / Charges
- Referral Bonus system
- Local Holiday payments

### Sprint 5 (Semanas 9-10): Anniversary + Seniority
- Anniversary adjustment report + approval
- Seniority Bonus
- Part-time rules BK

### Sprint 6 (Semanas 11-12): Frontend Hub completo
- Dashboard consolidado
- Desprendible de pago
- Invoice del cliente
- Configuración por país

### Sprint 7 (Semanas 13-14): Testing + UAT
- Testing completo
- UAT con equipo
- Migración final en producción

---

## DEPENDENCIAS Y RIESGOS

| Riesgo | Mitigación |
|---|---|
| Fórmula de Client Price no definida | **BLOQUEANTE**: Necesitar fórmula de Violeta/Male antes de Sprint 2 |
| Reglas de part-time BK no claras | Reunión de clarificación antes de Sprint 5 |
| Festivos USA vs locales para Holiday Pay | Crear lista maestra de festivos USA excluidos (Dic 24, Ene 1, Oct 12, etc.) |
| Datos incompletos en Power App | Validación exhaustiva en script de migración |
| Cálculos retroactivos | Definir desde qué fecha aplican los nuevos cálculos |

## PREGUNTAS PENDIENTES
1. ¿La fórmula de Client Price es la misma para todos los clientes o varía?
2. ¿Los festivos de USA exentos son siempre los mismos o cambian por año?
3. ¿Las reglas de part-time BK aplican solo a BK o a otros clientes?
4. ¿Hay históricos de IPB/bonos en Power App que deban migrarse?
5. ¿El seniority bonus se calcula sobre el basic pay original o el ajustado por aniversario?
6. ¿El aumento de aniversario es 5% simple o compuesto?
