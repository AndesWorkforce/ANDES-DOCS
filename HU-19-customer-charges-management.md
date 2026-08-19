# HU-19: Gestión de Cargos al Cliente en Contexto de Factura

## Resumen

Esta historia de usuario implementa la gestión completa (CRUD + aprobar + anular) de cargos al cliente dentro del contexto de una factura. Los cargos permiten agregar cobros adicionales a las facturas de los clientes.

## Endpoints Backend

Todos los endpoints están bajo `/admin-hub/customer-charges`:

### 1. Crear Cargo
- **Endpoint**: `POST /admin-hub/customer-charges`
- **Autenticación**: Requerida (JWT)
- **Body**:
  ```json
  {
    "empresaId": "uuid",
    "procesoContratacionId": "uuid (opcional)",
    "tipo": "EQUIPO | TEAM_BUILDING | CAPACITACION | OTRO",
    "monto": 350.00,
    "moneda": "USD",
    "fecha": "2026-07-29",
    "periodo": "2026-07",
    "descripcion": "Descripción del cargo",
    "notas": "Notas adicionales",
    "metodoPago": "Transferencia bancaria",
    "afectaNomina": false,
    "comprobantes": [],
    "detalles": "Detalles completos del cargo"
  }
  ```
- **Estado Inicial**: `PENDIENTE`

### 2. Listar Cargos
- **Endpoint**: `GET /admin-hub/customer-charges`
- **Query Params**: `empresaId`, `procesoContratacionId`, `periodo`, `estado`, `tipo`
- **Retorna**: Array de cargos con toda su información

### 3. Obtener Detalle
- **Endpoint**: `GET /admin-hub/customer-charges/:id`
- **Retorna**: Cargo completo con relaciones (empresa, proceso contratación)

### 4. Actualizar Cargo
- **Endpoint**: `PATCH /admin-hub/customer-charges/:id`
- **Restricción**: Solo cargos en estado `PENDIENTE`
- **Campos Editables**: monto, tipo, fecha, periodo, descripción, notas, metodoPago, afectaNomina, comprobantes, detalles

### 5. Aprobar Cargo
- **Endpoint**: `POST /admin-hub/customer-charges/:id/aprobar`
- **Transición**: `PENDIENTE → APROBADO`
- **Body (opcional)**:
  ```json
  {
    "notasAprobacion": "Cargo validado con factura adjunta"
  }
  ```

### 6. Anular Cargo
- **Endpoint**: `POST /admin-hub/customer-charges/:id/anular`
- **Transición**: `PENDIENTE/APROBADO → ANULADO`
- **Restricción**: No se puede anular un cargo ya facturado

## Implementación Frontend

### 1. Actions (`pagos.actions.ts`)

Se agregaron las siguientes actions del lado del servidor:

```typescript
// Tipos
export type TipoCargoCliente = "EQUIPO" | "TEAM_BUILDING" | "CAPACITACION" | "OTRO";
export type EstadoCargoCliente = "PENDIENTE" | "APROBADO" | "ANULADO";

// Functions
createCustomerCharge(data: CreateCustomerChargeDto): Promise<ApiResponse>
getCustomerCharges(filters?: {...}): Promise<ApiResponse>
getCustomerCharge(id: string): Promise<ApiResponse>
updateCustomerCharge(id: string, data: UpdateCustomerChargeDto): Promise<ApiResponse>
approveCustomerCharge(id: string, data?: ApproveCustomerChargeDto): Promise<ApiResponse>
cancelCustomerCharge(id: string): Promise<ApiResponse>
```

### 2. CreateInvoiceItemDrawer

**Nuevos Props**:
- `empresaId: string` - ID de la empresa para crear el cargo
- `periodo: string` - Periodo de facturación (formato: YYYY-MM)
- `onChargeCreated?: () => void` - Callback al crear cargo exitosamente

**Flujo de Creación de Cargo**:
1. Usuario selecciona "Cargos al cliente" en el drawer
2. Completa el formulario (tipo, descripción, monto, moneda)
3. Al guardar, se llama a `createCustomerCharge` con los datos
4. Si es exitoso: muestra notificación y ejecuta `onChargeCreated()` (que hace `router.refresh()`)
5. Si falla: muestra mensaje de error

**Mapeo de Tipos**:
```typescript
const tipoMap: Record<string, TipoCargoCliente> = {
  "team-building": "TEAM_BUILDING",
  equipamiento: "EQUIPO",
  capacitacion: "CAPACITACION",
};
```

### 3. InvoiceDetailContent

**Modificaciones**:

1. **Importaciones**:
   ```typescript
   import { 
     emitInvoice, 
     approveCustomerCharge, 
     cancelCustomerCharge 
   } from "../actions/pagos.actions";
   ```

2. **handleApproveItem** (async):
   - Si la sección es `customer-charges`:
     - Llama a `approveCustomerCharge(itemId)`
     - Muestra notificación de éxito/error
     - Hace `router.refresh()` para actualizar datos
   - Si es otra sección: usa lógica local (updateItemStatus)

3. **handleDeleteItem** (async):
   - Si la sección es `customer-charges`:
     - Llama a `cancelCustomerCharge(itemId)`
     - Muestra notificación de éxito/error
     - Hace `router.refresh()` para actualizar datos
   - Si es otra sección: usa lógica local (elimina del estado)

4. **CreateInvoiceItemDrawer**:
   ```typescript
   <CreateInvoiceItemDrawer
     open={isCreateItemOpen}
     client={invoice.client}
     empresaId={invoice.empresaId}
     periodo={invoice.period}
     onClose={() => setIsCreateItemOpen(false)}
     onItemCreated={handleItemCreated}
     onAdditionalFeeCreated={handleAdditionalFeeCreated}
     onChargeCreated={() => router.refresh()}
   />
   ```

## Flujo de Uso

### Crear Cargo
1. En la página de detalle de factura, click en botón "Crear ítem"
2. Seleccionar "Cargos al cliente"
3. Completar formulario:
   - Tipo de cargo (Team Building, Equipamiento, Capacitación)
   - Descripción
   - Monto
   - Moneda
4. Click en "Crear movimiento"
5. El cargo se crea en estado `PENDIENTE`
6. La página se recarga automáticamente para mostrar el nuevo cargo

### Aprobar Cargo
1. En la tabla de cargos, ubicar el cargo en estado `PENDIENTE`
2. Click en botón "Aprobar"
3. El cargo pasa a estado `APROBADO`
4. Se registra quién aprobó y cuándo
5. La página se recarga para reflejar el cambio

### Anular Cargo
1. En la tabla de cargos, ubicar el cargo a anular
2. Click en botón "Eliminar" (que internamente llama a anular)
3. El cargo pasa a estado `ANULADO`
4. La página se recarga para reflejar el cambio

## Criterios de Aceptación

### CA-1: Crear cargo aparece en tab cargos ✓
- Al guardar el drawer con tipo "Cargos al cliente"
- El cargo se crea en backend con estado `PENDIENTE`
- La página se recarga y muestra el nuevo cargo en la sección correspondiente

### CA-2: Aprobar cargo pendiente ✓
- Cargo en estado `PENDIENTE` puede ser aprobado
- Al aprobar, el estado cambia a `APROBADO`
- Se registra información de aprobación (usuario, fecha, notas)

### CA-3: Anular cargo refleja en factura ✓
- Al anular un cargo, el estado cambia a `ANULADO`
- El cargo anulado se refleja inmediatamente en el detalle de la factura
- Los totales se recalculan automáticamente

### CA-4: Eliminar cargo desaparece del detalle ✓
- Al "eliminar" (anular) un cargo, se marca como `ANULADO`
- El cargo ya no aparece en los cálculos activos
- Se mantiene el registro histórico en la base de datos

## Validaciones Backend

1. **Crear**:
   - Empresa debe existir
   - Proceso contratación debe existir (si se proporciona)
   - Monto debe ser > 0
   - Periodo debe tener formato YYYY-MM
   - Tipo debe ser uno de los valores del enum

2. **Actualizar**:
   - Solo cargos en estado `PENDIENTE`
   - Monto debe ser > 0 si se actualiza

3. **Aprobar**:
   - Solo desde estado `PENDIENTE`

4. **Anular**:
   - Desde `PENDIENTE` o `APROBADO`
   - No se puede anular si ya está facturado

## Integración con Facturación

Los cargos aprobados se incluyen automáticamente en:
1. **ClientInvoiceSnapshot**: Al generar el snapshot de la factura
2. **Cálculo de totales**: Los cargos `APROBADO` suman al total de la factura
3. **Detalle de factura**: Aparecen en la sección "Cargos al cliente"

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
4. **Mapeo de tipos**: Los tipos del formulario se mapean a los enums del backend

## Archivos Modificados

### Frontend
- `src/app/admin-hub/pagos/actions/pagos.actions.ts` (nuevo: customer charges actions)
- `src/app/admin-hub/pagos/components/CreateInvoiceItemDrawer.tsx` (actualizado)
- `src/app/admin-hub/pagos/components/InvoiceDetailContent.tsx` (actualizado)

### Backend (ya existían)
- `src/admin-hub/customer-charges/customer-charges.controller.ts`
- `src/admin-hub/customer-charges/customer-charges.service.ts`
- `src/admin-hub/customer-charges/dto/*.dto.ts`

## Testing

### Manual
1. Crear cargo con diferentes tipos
2. Aprobar cargo pendiente
3. Intentar aprobar cargo ya aprobado (debe fallar)
4. Anular cargo pendiente
5. Anular cargo aprobado
6. Intentar editar cargo aprobado (debe fallar)
7. Verificar que cargos se reflejen en totales de factura

### Casos Edge
- Cargo con monto muy grande
- Cargo con caracteres especiales en descripción
- Cargo sin periodo especificado
- Multiple cargos al mismo tiempo
- Cargo con proceso contratación inexistente
