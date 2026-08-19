# HU-20: Gestión de Créditos al Cliente en Contexto de Factura

## Resumen

Esta historia de usuario implementa la gestión de créditos al cliente (crear, aprobar, eliminar) dentro del contexto de una factura. Los créditos permiten aplicar descuentos y ajustes que restan del total de la factura.

## Endpoints Backend

Todos los endpoints están bajo `/admin-hub/customer-credits`:

### 1. Crear Crédito
- **Endpoint**: `POST /admin-hub/customer-credits`
- **Autenticación**: Requerida (JWT)
- **Body**:
  ```json
  {
    "empresaId": "uuid",
    "procesoContratacionId": "uuid (opcional)",
    "periodo": "2026-07",
    "tipo": "CREDIT",
    "monto": 150.00,
    "categoria": "RENUNCIA | DESPIDO | BONO | PENALIZACION | OTRO",
    "motivo": "Descripción del crédito",
    "referencia": "INV-2026-042",
    "fecha": "2026-07-29"
  }
  ```
- **Estado Inicial**: `PENDING`

### 2. Listar Créditos
- **Endpoint**: `GET /admin-hub/customer-credits`
- **Query Params**: `empresaId`, `procesoContratacionId`, `periodo`, `estado`, `tipo`, `categoria`
- **Retorna**: Array de créditos con toda su información

### 3. Obtener Detalle
- **Endpoint**: `GET /admin-hub/customer-credits/:id`
- **Retorna**: Crédito completo con relaciones (empresa, proceso contratación)

### 4. Actualizar Crédito
- **Endpoint**: `PATCH /admin-hub/customer-credits/:id`
- **Restricción**: Solo créditos en estado `PENDING`
- **Campos Editables**: monto, motivo, referencia, fecha

### 5. Aprobar Crédito
- **Endpoint**: `POST /admin-hub/customer-credits/:id/aprobar`
- **Transición**: `PENDING → APPROVED`
- **Body (opcional)**:
  ```json
  {
    "notasAprobacion": "Crédito validado por gerencia"
  }
  ```

## Diferencias con Customer Charges

| Aspecto | Customer Charges | Customer Credits |
|---------|-----------------|------------------|
| Modelo Backend | `CustomerCharge` | `AjusteFacturaCliente` |
| Estados | PENDIENTE, APROBADO, ANULADO | PENDING, PROJECTED, APPROVED |
| Tipos | EQUIPO, TEAM_BUILDING, CAPACITACION, OTRO | CREDIT, CHARGE |
| Categorías | N/A | RENUNCIA, DESPIDO, BONO, PENALIZACION, OTRO |
| Endpoint Eliminar | POST /:id/anular | No existe (eliminación local) |
| Impacto en Total | Suma al total | Resta del total |

## Implementación Frontend

### 1. Actions (`pagos.actions.ts`)

Se agregaron las siguientes actions del lado del servidor:

```typescript
// Tipos
export type TipoAjusteFactura = "CREDIT" | "CHARGE";
export type EstadoAjusteFactura = "PENDING" | "PROJECTED" | "APPROVED";
export type CategoriaAjusteFactura = "RENUNCIA" | "DESPIDO" | "BONO" | "PENALIZACION" | "OTRO";

// Functions
createCustomerCredit(data: CreateCustomerCreditDto): Promise<ApiResponse>
getCustomerCredits(filters?: {...}): Promise<ApiResponse>
getCustomerCredit(id: string): Promise<ApiResponse>
updateCustomerCredit(id: string, data: UpdateCustomerCreditDto): Promise<ApiResponse>
approveCustomerCredit(id: string, data?: ApproveCustomerCreditDto): Promise<ApiResponse>
```

### 2. CreateInvoiceItemDrawer

**Cambios**:
- Importar `createCustomerCredit` y `CategoriaAjusteFactura`
- Implementar lógica para crear créditos vía API
- Mapear categorías del formulario a enums del backend

**Flujo de Creación de Crédito**:
1. Usuario selecciona "Créditos al cliente" en el drawer
2. Completa el formulario (tipo/categoría, descripción/motivo, monto)
3. Al guardar, se llama a `createCustomerCredit` con:
   - `tipo: "CREDIT"` (fijo)
   - `categoria`: mapeada del tipo del formulario
   - `motivo`: de la descripción del formulario
4. Si es exitoso: muestra notificación y ejecuta `onChargeCreated()` (que hace `router.refresh()`)
5. Si falla: muestra mensaje de error

**Mapeo de Categorías**:
```typescript
const categoriaMap: Record<string, CategoriaAjusteFactura> = {
  renuncia: "RENUNCIA",
  despido: "DESPIDO",
  bono: "BONO",
  penalizacion: "PENALIZACION",
};
```

### 3. InvoiceDetailContent

**Modificaciones**:

1. **Importaciones**:
   ```typescript
   import { 
     emitInvoice, 
     approveCustomerCharge, 
     cancelCustomerCharge,
     approveCustomerCredit
   } from "../actions/pagos.actions";
   ```

2. **handleApproveItem** (async):
   - Si la sección es `customer-credits`:
     - Llama a `approveCustomerCredit(itemId)`
     - Muestra notificación de éxito/error
     - Hace `router.refresh()` para actualizar datos
   - Si es `customer-charges`: usa `approveCustomerCharge`
   - Si es otra sección: usa lógica local (updateItemStatus)

3. **handleDeleteItem**:
   - `customer-credits` se eliminan localmente (no hay endpoint de anular)
   - `customer-charges` usan API (`cancelCustomerCharge`)
   - Otros ítems se eliminan localmente

## Flujo de Uso

### Crear Crédito
1. En la página de detalle de factura, click en botón "Crear ítem"
2. Seleccionar "Créditos al cliente"
3. Completar formulario:
   - Categoría del crédito (Renuncia, Despido, Bono, Penalización, Otro)
   - Motivo/Descripción
   - Monto
4. Click en "Crear movimiento"
5. El crédito se crea en estado `PENDING`
6. La página se recarga automáticamente para mostrar el nuevo crédito

### Aprobar Crédito
1. En la tabla de créditos, ubicar el crédito en estado `PENDING`
2. Click en botón "Aprobar"
3. El crédito pasa a estado `APPROVED`
4. Se registra quién aprobó y cuándo
5. La página se recarga para reflejar el cambio

### Eliminar Crédito
1. En la tabla de créditos, ubicar el crédito a eliminar
2. Click en botón "Eliminar"
3. El crédito se elimina del estado local
4. Los totales se recalculan automáticamente
5. **Nota**: La eliminación es solo local, no hay endpoint de eliminación en backend

## Criterios de Aceptación

### CA-1: Crear crédito aparece en tab créditos ✓
- Al guardar el drawer con tipo "Créditos al cliente"
- El crédito se crea en backend con estado `PENDING`
- La página se recarga y muestra el nuevo crédito en la sección correspondiente

### CA-2: Aprobar crédito pendiente ✓
- Crédito en estado `PENDING` puede ser aprobado
- Al aprobar, el estado cambia a `APPROVED`
- Se registra información de aprobación (usuario, fecha, notas)

### CA-3: Montos negativos calculan correctamente ✓
- Los créditos se muestran con montos negativos en la UI
- Al calcular subtotales, los créditos restan del total
- El cálculo del grand total incluye correctamente los créditos

### CA-4: Eliminar crédito actualiza totales ✓
- Al eliminar un crédito, se actualiza el estado local
- Los subtotales y el total general se recalculan
- El cambio se refleja inmediatamente en la UI

## Validaciones Backend

1. **Crear**:
   - Empresa debe existir
   - Proceso contratación debe existir (si se proporciona)
   - Monto debe ser > 0
   - Periodo debe tener formato YYYY-MM
   - Tipo debe ser CREDIT o CHARGE

2. **Actualizar**:
   - Solo créditos en estado `PENDING`
   - Monto debe ser > 0 si se actualiza

3. **Aprobar**:
   - Solo desde estado `PENDING` o `PROJECTED`

## Integración con Facturación

Los créditos aprobados se incluyen automáticamente en:
1. **ClientInvoiceSnapshot**: Al generar el snapshot de la factura
2. **Cálculo de totales**: Los créditos `APPROVED` restan del total de la factura
3. **Detalle de factura**: Aparecen en la sección "Créditos al cliente" con montos negativos

## Manejo de Errores

### Frontend
- Muestra notificaciones de error con mensaje descriptivo
- Mantiene el estado del drawer/modal abierto en caso de error
- No actualiza la UI hasta confirmar éxito del backend

### Backend
- Retorna códigos HTTP apropiados (400, 404, 409)
- Mensajes de error descriptivos en español
- Valida todas las transiciones de estado

## Notas Técnicas

1. **Router Refresh**: Se usa `router.refresh()` para recargar los datos sin perder el estado de la página
2. **Estado Optimista**: No se usa; se espera confirmación del backend
3. **Notificaciones**: Se usan notificaciones temporales (5 segundos)
4. **Montos Negativos**: Los créditos se muestran y calculan como negativos
5. **Eliminación Local**: No hay endpoint de eliminación, se maneja en el estado local

## Archivos Modificados

### Frontend
- `src/app/admin-hub/pagos/actions/pagos.actions.ts` (nuevo: customer credits actions)
- `src/app/admin-hub/pagos/components/CreateInvoiceItemDrawer.tsx` (actualizado)
- `src/app/admin-hub/pagos/components/InvoiceDetailContent.tsx` (actualizado)

### Backend (ya existían)
- `src/admin-hub/customer-credits/customer-credits.controller.ts`
- `src/admin-hub/customer-credits/customer-credits.service.ts`
- `src/admin-hub/customer-credits/dto/*.dto.ts`

## Testing

### Manual
1. Crear crédito con diferentes categorías
2. Aprobar crédito pendiente
3. Verificar que créditos aparecen como negativos
4. Eliminar crédito (local)
5. Verificar que créditos restan correctamente del total
6. Intentar aprobar crédito ya aprobado (debe fallar)
7. Intentar editar crédito aprobado (debe fallar)

### Casos Edge
- Crédito con monto muy grande
- Crédito con caracteres especiales en motivo
- Crédito sin fecha especificada
- Multiple créditos al mismo tiempo
- Crédito con proceso contratación inexistente
- Crédito que hace que el total de factura sea negativo

## Comparación con HU-19

| Característica | HU-19 (Cargos) | HU-20 (Créditos) |
|----------------|----------------|------------------|
| **Propósito** | Agregar cobros adicionales | Aplicar descuentos y ajustes |
| **Impacto en Total** | Suma (+) | Resta (-) |
| **Modelo Backend** | CustomerCharge | AjusteFacturaCliente |
| **Estados** | PENDIENTE, APROBADO, ANULADO | PENDING, PROJECTED, APPROVED |
| **Endpoint Anular** | Sí (POST /:id/anular) | No (eliminación local) |
| **Tipos** | EQUIPO, TEAM_BUILDING, etc. | Categorías: RENUNCIA, DESPIDO, etc. |
| **Campos** | tipo, monto, descripcion | tipo, monto, categoria, motivo |

## Mejoras Futuras

1. Agregar endpoint de anulación en backend para créditos
2. Implementar validación de total negativo
3. Agregar historial de cambios
4. Permitir adjuntar comprobantes
5. Implementar aprobación en batch
