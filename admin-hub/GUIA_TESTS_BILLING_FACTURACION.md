# Tests — Facturación al Cliente (Billing Summary)

Guía de los tests del flujo de facturación mensual al cliente en el módulo **Admin Hub**.

Creado: 2026-05-21

---

## Archivos de test

| Archivo | Tipo | Descripción |
|---|---|---|
| `src/admin-hub/billing-summary/billing-summary.service.spec.ts` | Unit | 32 casos unitarios para `facturacionCliente()` |
| `test/billing-summary-facturacion.e2e-spec.ts` | E2E | Flujo completo: charges + credits + income vars → total factura |

---

## Cómo correr los tests

### Unit tests (sin DB)

```bash
# Solo billing-summary
pnpm test -- --testPathPattern="billing-summary.service.spec" --verbose

# Todos los unit tests del módulo admin-hub
pnpm test -- --testPathPattern="admin-hub" --verbose
```

### E2E (requiere DB local)

```bash
# Requiere DATABASE_URL apuntando a andes_admin_hub
$env:DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/andes_admin_hub?schema=public"

# Solo billing-summary e2e
pnpm test:e2e -- --testPathPattern="billing-summary-facturacion" --verbose

# Todos los e2e
pnpm test:e2e
```

> El test e2e usa el periodo `2026-07` para aislarse de otros tests (`2026-05` y `2026-06`). Limpia automáticamente los registros antes y después de ejecutarse.

---

## Endpoint bajo prueba

```
GET /api/billing-summary/facturacion/:empresaId/:periodo
```

**Guards**: `JwtAuthGuard` + `AdminRoleGuard`  
**Periodo**: formato `YYYY-MM` (ej. `2026-07`)

### Estructura de respuesta

```json
{
  "data": {
    "empresa": { "id": "...", "nombre": "..." },
    "periodo": "2026-07",
    "contratos": [
      {
        "procesoContratacionId": "...",
        "nombreCompleto": "...",
        "clientPrice": 2000,
        "descuentosAusencias": 0,
        "netContrato": 2000
      }
    ],
    "customerCharges": { "total": 500, "cantidad": 1, "items": [...] },
    "customerCredits": { "total": 200, "cantidad": 1, "items": [...] },
    "incomeVariables": { "total": 280, "cantidad": 2, "items": [...] },
    "resumen": {
      "clientPriceTotal": 0,
      "descuentosAusenciasTotal": 0,
      "customerChargesTotal": 500,
      "customerCreditsTotal": 200,
      "incomeVariablesTotal": 280,
      "totalFacturarEstimado": 980,
      "formula": "clientPrice(0) − ausencias(0) + charges(500) + credits(200) + incomeVars(280) = 980",
      "nota": "Sin contratos con snapshot IPB para este periodo..."
    }
  }
}
```

---

## Fórmula de facturación

```
totalFacturar = clientPriceTotal
              − descuentosAusenciasTotal
              + customerChargesTotal   (PENDIENTE + APROBADO)
              + customerCreditsTotal   (solo APPROVED)
              + incomeVariablesTotal   (INVOICE_EXPENSE APPROVED, usa montoFactura ?? monto)
```

### Reglas de inclusión por estado

| Entidad | Estado incluido | Estado excluido |
|---|---|---|
| `CustomerCharge` | `PENDIENTE`, `APROBADO` | `ANULADO`, `FACTURADO` |
| `AjusteFacturaCliente` (credits) | `APPROVED` | `PENDING`, `PROJECTED`, `ANULADO` |
| `IncomeVariable` INVOICE_EXPENSE | `APPROVED` + `afectaFactura=true` | `PENDING`, `ANULADO` |
| `IpbMensualSnapshot` | todos los del periodo | — |

### montoFactura vs monto en Income Variables

Las `IncomeVariable` de categoría `INVOICE_EXPENSE` pueden tener dos montos distintos:

- **`monto`**: lo que recibe el contratista (pago interno)
- **`montoFactura`**: lo que se cobra al cliente (puede incluir margen)

La facturación siempre usa `montoFactura ?? monto`. Si `montoFactura` es `null`, usa `monto`.

**Ejemplo:**
```
monto = 100      → pago al contratista
montoFactura = 130 → cobro al cliente (margen de servicio incluido)
Factura usa: 130
```

---

## Casos cubiertos en unit tests (32 tests)

### Validación de entrada

| Caso | Entrada | Resultado esperado |
|---|---|---|
| Formato de periodo inválido | `'202605'`, `'2026-5'`, `'mayo-2026'`, `''` | `BadRequestException` |
| Empresa no existe | `empresaId` sin registro | `NotFoundException` |
| Periodos válidos | `'2026-01'`, `'2026-12'` | Sin error |

### Sin snapshots IPB

| Caso | Resultado esperado |
|---|---|
| Sin nada | `contratos=[]`, `totalFacturarEstimado=0` |
| Nota informativa | `resumen.nota` contiene `"Sin contratos"` |
| No llama a ausencias | `resumenContratoMes` no es invocado |

### Con snapshots IPB

| Caso | Resultado esperado |
|---|---|
| `clientPrice=2000` | `clientPriceTotal=2000`, `total=2000` |
| `clientPrice=null` | Fallback a `basicPay=1000` |
| Ausencias `200` | `total = 2000 − 200 = 1800` |
| Error en ausencias | Trata como `0`, no rompe el flujo |
| Dos contratos | `clientPriceTotal = 2000 + 3000 = 5000` |

### Customer Charges

| Caso | Resultado esperado |
|---|---|
| `300 PENDIENTE + 200 APROBADO` | `chargesTotal=500`, `cantidad=2` |
| Sin charges | `chargesTotal=0` |
| Query filtra estados | Solo `[PENDIENTE, APROBADO]` en el `where` |
| Fórmula `2000 + 500` | `totalFacturarEstimado=2500` |

### Customer Credits

| Caso | Resultado esperado |
|---|---|
| `150 APPROVED` | `creditsTotal=150`, `cantidad=1` |
| Sin credits | `creditsTotal=0` |
| Query filtra estado | Solo `APPROVED` en el `where` |

### Income Variables (INVOICE_EXPENSE)

| Caso | Resultado esperado |
|---|---|
| `montoFactura=250`, `monto=200` | Usa `250` |
| `montoFactura=null`, `monto=180` | Usa `180` |
| Dos items mixtos `(120+80)` | `incomeVarsTotal=200` |
| Sin income vars | `incomeVarsTotal=0` |
| Query filtra | `afectaFactura=true` + `estado=APPROVED` |

### Fórmula completa (valores concretos)

```
clientPrice(2000) − ausencias(0) + charges(500) + credits(150) + incomeVars(250) = 2900
```

Además: descuento ausencias `2000−100=1900`, dos contratos `5000`.

---

## Flujo del test E2E (periodo `2026-07`)

El test construye estado de forma secuencial. Cada step verifica el `totalFacturarEstimado`:

```
Paso 1 — Estado base                         → total = $0
Paso 2 — Crear charge PENDIENTE $500         → total = $500
Paso 3 — Crear charge PENDIENTE $300         → total = $800
Paso 4 — Aprobar charge $500                 → total = $800  (APROBADO sigue contando)
Paso 5 — Anular charge $300                  → total = $500  (ANULADO excluido)
Paso 6 — Crear credit PENDING $200           → total = $500  (PENDING no cuenta)
Paso 7 — Aprobar credit $200                 → total = $700
Paso 8 — Crear income var PENDING $150       → total = $700  (PENDING no cuenta)
Paso 9 — Aprobar income var $150             → total = $850
Paso 10 — Crear + aprobar income var         → total = $980
          monto=100 / montoFactura=130                   (usa montoFactura=130)
```

**Total final esperado:** `charges(500) + credits(200) + incomeVars(150+130) = 980`

### Casos de error cubiertos en E2E

| Acción | Respuesta esperada |
|---|---|
| Sin token | `401` |
| Periodo `202607` (sin guión) | `400` |
| Periodo `julio-2026` (texto) | `400` |
| Empresa UUID inexistente | `404` |
| Re-anular charge ya ANULADO | `409` |
| Editar charge APROBADO | `409` |
| Re-aprobar credit ya APPROVED | `409` |
| Crear charge con `monto=0` | `400` |

---

## Fixture IDs de referencia

```
EMPRESA_ID  = aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaa0001
PROCESO_ID  = aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaa0007  (clientPrice=2000, basicPay=1000)
ADMIN_ID    = aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaa0003
```

---

## Tests existentes relacionados

| Archivo | Tipo | Cobertura |
|---|---|---|
| `customer-charges.service.spec.ts` | Unit | create, findAll, findOne, update, aprobar, anular, sumByPeriodo |
| `customer-charges.controller.spec.ts` | Unit | Delegación de todos los métodos al service |
| `test/customer-charges.e2e-spec.ts` | E2E | Flujo completo PENDIENTE → APROBADO → ANULADO + test bulk equipos |
| `customer-credits.service.spec.ts` | Unit | create, findAll, findOne, update, aprobar |
| `customer-credits.controller.spec.ts` | Unit | Delegación de todos los métodos |
| `test/customer-credits.e2e-spec.ts` | E2E | Flujo completo PENDING → APPROVED + filtros |
