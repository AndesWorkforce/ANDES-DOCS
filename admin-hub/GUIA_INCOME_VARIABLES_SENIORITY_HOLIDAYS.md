# Admin-Hub: Guía de Variables de Ingreso, Seniority Bonus y Holidays

> **Audiencia:** Desarrolladores del equipo Andes Workforce  
> **Rama:** `admin-hub`  
> **Commit de referencia:** `edc4d28`  
> **Fecha:** 2026-05-20

---

## 1. Módulo Income Variables

### ¿Qué es?

`IncomeVariable` es un registro mensual de ajuste de nómina o facturación para un contratista. Cada variable está asociada a un `ProcesoContratacion` y a una `Empresa`, tiene un periodo `YYYY-MM` y sigue un flujo de aprobación antes de impactar los cálculos.

### Modelo de datos

```prisma
model IncomeVariable {
  id                    String                   @id @default(uuid())
  procesoContratacionId String
  empresaId             String
  periodo               String                   // "YYYY-MM"
  categoria             CategoriaVariableIngreso
  monto                 Decimal                  @db.Decimal(12, 2)
  montoFactura          Decimal?                 @db.Decimal(12, 2) // solo INVOICE_EXPENSE
  nota                  String                   // OBLIGATORIO — justificación
  afectaFactura         Boolean                  @default(false)
  recurrente            Boolean                  @default(false)    // bonos permanentes
  estado                EstadoVariableIngreso    @default(PENDING)
  creadoPorId           String?
  aprobadoPorId         String?
  aprobadoEn            DateTime?
  notasAprobacion       String?
}
```

### Categorías (`CategoriaVariableIngreso`)

| Categoría | `afectaFactura` | Descripción |
|---|---|---|
| `BONUS` | `false` | Bonus de cualquier tipo (rendimiento, antigüedad, etc.) — solo nómina |
| `REIMBURSEMENT` | `false` | Reembolso al contratista |
| `OTHER` | `false` | Ajuste genérico (puede ser negativo para descuentos) |
| `INVOICE_EXPENSE` | `true` | Gasto que se factura al cliente **y** se paga al contratista |

> **`INVOICE_EXPENSE` y `montoFactura`:** Si el cliente paga un monto diferente al que recibe el contratista, se envía `montoFactura` con lo que se cobra al cliente. Si `montoFactura` es `null`, se usa `monto` para ambos cálculos.

### Estados (`EstadoVariableIngreso`)

```
PENDING → APPROVED  (via POST /:id/aprobar)
PENDING → ANULADO   (via POST /:id/anular)
APPROVED → ANULADO  (via POST /:id/anular)
```

Solo los registros en estado `APPROVED` impactan nómina y facturación.

### Endpoints

**Prefijo global:** `/api/income-variables`  
**Autenticación:** `Bearer JWT` — roles `ADMIN`, `EMPLEADO_ADMIN`

| Método | Ruta | Descripción |
|---|---|---|
| `POST` | `/` | Crear variable |
| `GET` | `/` | Listar (filtros: `procesoContratacionId`, `empresaId`, `periodo`, `categoria`, `estado`) |
| `GET` | `/sum/:procesoContratacionId/:periodo` | Suma total APPROVED para nómina del contratista en el periodo |
| `GET` | `/sum-factura/:empresaId/:periodo` | Suma INVOICE_EXPENSE APPROVED por empresa en el periodo (usa `montoFactura ?? monto`) |
| `GET` | `/elegibilidad-antiguedad/:procesoContratacionId` | Ver sección Seniority Bonus |
| `POST` | `/aplicar-antiguedad/:procesoContratacionId` | Ver sección Seniority Bonus |
| `GET` | `/:id` | Obtener una variable |
| `PATCH` | `/:id` | Actualizar (solo si está en `PENDING`) |
| `POST` | `/:id/aprobar` | Aprobar — body: `{ notasAprobacion?: string }` |
| `POST` | `/:id/anular` | Anular — body: `{ motivoAnulacion: string }` |

### DTO de creación

```typescript
{
  procesoContratacionId: string   // UUID
  empresaId: string               // UUID
  periodo: string                 // "YYYY-MM"
  categoria: CategoriaVariableIngreso
  monto: number                   // monto que recibe el contratista
  nota: string                    // OBLIGATORIO — justificación del ajuste
  montoFactura?: number           // solo si INVOICE_EXPENSE y monto cliente ≠ monto contratista
}
```

### Impacto en billing-summary

- **`sumNomina`** → suma `monto` de todos los APPROVED del contratista en el periodo.  
  Se añade a `netNomina = basicPay − descuentosAusencias + montoBonus + incomeVarsTotal`.

- **`sumFactura`** → suma `montoFactura ?? monto` de los INVOICE_EXPENSE APPROVED de la empresa en el periodo.  
  Se muestra separado en el reporte de facturación al cliente.

---

## 2. Seniority Bonus (Bono de Antigüedad)

### Regla de negocio

Un contratista gana un nivel de antigüedad **por cada 2 años cumplidos** de servicio:

| Años de servicio | Nivel | Bono mensual (basicPay = $1,000) |
|---|---|---|
| 0 – 1.99 | 0 | No elegible |
| 2 – 3.99 | 1 | 1 × 25% × basicPay ÷ 12 = **$20.83** |
| 4 – 5.99 | 2 | 2 × 25% × basicPay ÷ 12 = **$41.67** |
| 6 – 7.99 | 3 | 3 × 25% × basicPay ÷ 12 = **$62.50** |

**Fórmula:** `nivelAntiguedad × basicPay × 0.25 / 12`  
**Nivel:** `Math.floor(aniosServicio / 2)`

### Fecha de referencia

El servicio toma la primera fecha disponible en este orden:
1. `fechaInicioLabores`
2. `fechaInicioContrato`
3. `fechaInicio`

### Flujo de aplicación

1. **Verificar elegibilidad** (lectura, no crea nada):
   ```
   GET /api/income-variables/elegibilidad-antiguedad/:procesoContratacionId
   ```
   Respuesta:
   ```json
   {
     "procesoContratacionId": "...",
     "nombreCompleto": "Juan Pérez",
     "fechaInicioLabores": "2022-01-01T00:00:00.000Z",
     "aniosServicio": 4.38,
     "nivelAntiguedad": 2,
     "isEligible": true,
     "basicPay": 1000,
     "moneda": "USD",
     "bonoMensual": 41.67,
     "formula": "nivelAntiguedad(2) × basicPay(1000) × 25% ÷ 12 = 41.67 USD/mes"
   }
   ```

2. **Aplicar bono** (crea el IncomeVariable):
   ```
   POST /api/income-variables/aplicar-antiguedad/:procesoContratacionId
   Body: { "empresaId": "...", "periodo": "2026-05" }
   ```
   - Crea un `IncomeVariable` con `categoria: BONUS`, `recurrente: true`, `afectaFactura: false`, estado `PENDING`.
   - La `nota` se auto-genera: `"Bono antigüedad nivel 2 (4.38a) — nivelAntiguedad(2) × basicPay(1000) × 25% ÷ 12 = 41.67 USD/mes"`.
   - **Idempotente:** si ya existe un bono recurrente BONUS activo para el mismo `procesoContratacionId` + `periodo`, devuelve `409 Conflict`.

3. **Aprobar** con el flujo normal:
   ```
   POST /api/income-variables/:id/aprobar
   Body: { "notasAprobacion": "Verificado" }
   ```

4. El bono queda visible en `GET /sum/:procesoContratacionId/:periodo` y en `billing-summary/nomina`.

### Campo `recurrente`

El campo `recurrente: true` **identifica** que esa variable es un bono permanente/recurrente. No automatiza nada — el analista lo aplica mes a mes manualmente usando el endpoint. Cuando el contratista cruce el umbral de 4 años, el mismo endpoint calculará automáticamente `nivel 2` con el monto actualizado.

---

## 3. Holidays (Días Festivos)

### Dos sistemas distintos — no confundirlos

El proyecto maneja **dos conceptos diferentes** relacionados con holidays:

---

### 3a. Holiday Bonus (Bono Discrecional) — `discretionaryBonusType`

Es una configuración **por contratista** que define qué bono anual recibe en junio/diciembre:

| Tipo | Descripción |
|---|---|
| `NONE` | Sin bono |
| `HALF_MONTH_ONCE_DECEMBER` | Medio mes en diciembre |
| `FULL_MONTH_ONCE_DECEMBER` | Mes completo en diciembre |
| `FULL_MONTH_TWICE_JUNE_DECEMBER` | Mes completo en junio y diciembre |

**Asignación** (admin-hub):
```
POST /api/compensation/:procesoContratacionId/holiday-bonus
Body: { "tipoBono": "FULL_MONTH_ONCE_DECEMBER" }
```

**Cálculo** (en billing-summary/nomina):  
- El bono se divide en 12 cuotas mensuales usando divisor fijo **20**.
- `basicPay / 20 = cuota mensual acumulada`. Al cumplirse el semestre se paga la suma acumulada.

---

### 3b. Local Holidays (Festivos Locales del País) — tabla `Holiday`

Son los días festivos nacionales registrados por país. Se usan para calcular el **pago adicional por trabajar en festivo** según la legislación local.

**Modelo:**
```prisma
model Holiday {
  id         String  @id @default(uuid())
  nombre     String
  dia        Int     // día del mes (1-31)
  mes        Int     // mes (1-12)
  pais       String
  codigoPais String
  activo     Boolean @default(true)
  // unique: pais + dia + mes
}
```

**Gestión** (CRUD — solo `ADMIN`):
```
POST   /holidays             → crear
GET    /holidays             → listar con paginación (filtros: pais, search)
GET    /holidays/countries   → países disponibles (público)
GET    /holidays/by-country/:countryName → festivos del país (público)
PATCH  /holidays/:id         → actualizar
DELETE /holidays/:id         → soft delete (activo: false)
```

**Uso en fórmulas** (`formulas.service.ts → calcularFestivosLocalesConValidacion`):
1. Recibe un array de fechas trabajadas.
2. Descarta fines de semana y festivos de USA.
3. Cruza contra la tabla `Holiday` del país del contratista.
4. Festivos locales válidos se multiplican por `tarifaFestivo` del país (configurado en la tabla `Pais`).
5. Fórmula: `tarifaDiaria × tarifaFestivo × diasAplicables`  
   donde `tarifaDiaria = basicPay / diasLaboralesMes`.

**Frontend (CLIENT-ANDES):**
- `/bonifications` — muestra la tabla de incentivos + los festivos del país del contratista logueado.
- `src/data/holidayCompensation.ts` — define multiplicadores por país (Colombia ×2, México ×3, etc.) solo para texto descriptivo en el frontend.

---

## 4. Cómo se conectan en Billing Summary

```
billing-summary/nomina/:procesoContratacionId/:periodo
```

```
netNomina =
  basicPay
  - descuentosAusencias           (días ausentes × tarifaDiaria)
  + montoBonus                    (discretionaryBonusType / 12 mensual)
  + incomeVarsTotal               (sum de IncomeVariable APPROVED del periodo)
  + festivosLocales               (dias festivos trabajados × tarifaFestivo)
```

```
billing-summary/facturacion/:empresaId/:periodo
```

```
totalFactura =
  sum(clientPrice de todos los procesos activos)
  + sum(montoFactura ?? monto  de INVOICE_EXPENSE APPROVED del periodo)
  - customerCredits APPROVED del periodo
  + customerCharges APPROVED del periodo
```

---

## 5. Flujo típico mensual del analista

```
1. Consultar elegibilidad seniority:
   GET /api/income-variables/elegibilidad-antiguedad/:procesoId

2. Si elegible → aplicar bono:
   POST /api/income-variables/aplicar-antiguedad/:procesoId
   { empresaId, periodo: "2026-05" }

3. Registrar otras variables del mes (gastos, reembolsos):
   POST /api/income-variables
   { procesoContratacionId, empresaId, periodo, categoria, monto, nota }
   // Para INVOICE_EXPENSE con monto cliente diferente: agregar montoFactura

4. Aprobar las variables:
   POST /api/income-variables/:id/aprobar
   { notasAprobacion: "OK" }

5. Consultar nómina final:
   GET /api/billing-summary/nomina/:procesoId/:periodo

6. Consultar facturación cliente:
   GET /api/billing-summary/facturacion/:empresaId/:periodo
```
