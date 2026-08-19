# Validación de Mapeo: Backend ↔ UI - Avisos

## Resumen

Se ha implementado la integración entre el backend (API) y el frontend (UI) para el sistema de avisos en Admin Hub. Este documento describe el mapeo entre los estados, tipos y prioridades del backend con los elementos de la interfaz de usuario.

---

## Mapeo de Estados

### Backend → UI (Tabs)

| Estado Backend | Tab UI | Descripción |
|---------------|---------|-------------|
| `PENDIENTE` | **No leídas** | Avisos que requieren atención |
| `REVISADO` | **No leídas** | Avisos revisados pero no resueltos |
| `RESUELTO` | **Leídas** | Avisos completados/resueltos |
| `ANULADO` | **Leídas** | Avisos anulados (ya atendidos) |

### Función de Mapeo

```typescript
function mapEstadoToLeida(estado: BackendEstadoAlerta): boolean {
  return estado === "RESUELTO" || estado === "ANULADO";
}
```

### Lógica de Filtrado por Tab

- **Tab "Todos"**: Muestra todos los avisos sin filtrar
- **Tab "No leídas"**: Filtra avisos con `leida === false` (PENDIENTE o REVISADO)
- **Tab "Leídas"**: Filtra avisos con `leida === true` (RESUELTO o ANULADO)

---

## Mapeo de Tipos de Alerta

### Backend → UI (Categorías)

| Tipo Backend | Categoría UI | Descripción |
|--------------|--------------|-------------|
| `NOMINA_PENDIENTE` | **Nóminas** | Nóminas pendientes de aprobación |
| `VARIABLE_INGRESO_PENDIENTE` | **Nóminas** | Variables de ingreso sin aprobar |
| `DEDUCCION_PENDIENTE` | **Nóminas** | Deducciones pendientes |
| `HORAS_EXTRA_PENDIENTE` | **Nóminas** | Horas extra sin registrar |
| `DIAS_LIBRES_PENDIENTE` | **Nóminas** | Días libres pendientes |
| `FACTURA_PENDIENTE` | **Facturación** | Facturas o gastos pendientes |
| `OTRO` | **Nóminas** | Otros avisos (default) |

### Función de Mapeo

```typescript
function mapTipoToCategoria(tipo: BackendTipoAlerta): AvisoCategory {
  switch (tipo) {
    case "NOMINA_PENDIENTE":
    case "VARIABLE_INGRESO_PENDIENTE":
    case "DEDUCCION_PENDIENTE":
    case "HORAS_EXTRA_PENDIENTE":
    case "DIAS_LIBRES_PENDIENTE":
      return "Nóminas";
    case "FACTURA_PENDIENTE":
      return "Facturación";
    default:
      return "Nóminas";
  }
}
```

---

## Generación de Action URLs

Las URLs de acción se generan automáticamente basándose en el tipo de alerta y los IDs relacionados:

| Tipo Backend | URL Generada | Condición |
|--------------|--------------|-----------|
| `NOMINA_PENDIENTE` | `/admin-hub/nominas/{nominaId}` | Si tiene nominaId |
| `NOMINA_PENDIENTE` | `/admin-hub/nominas` | Sin nominaId |
| `VARIABLE_INGRESO_PENDIENTE` | `/admin-hub/nominas/variables/{id}` | Si tiene incomeVariableId |
| `VARIABLE_INGRESO_PENDIENTE` | `/admin-hub/nominas/variables` | Sin incomeVariableId |
| `DEDUCCION_PENDIENTE` | `/admin-hub/nominas` | Siempre |
| `FACTURA_PENDIENTE` | `/admin-hub/pagos` | Siempre |
| `HORAS_EXTRA_PENDIENTE` | `/admin-hub/nominas` | Siempre |
| `DIAS_LIBRES_PENDIENTE` | `/admin-hub/nominas` | Siempre |
| `OTRO` | `/admin-hub/dashboard` | Fallback |

---

## Prioridades

Las prioridades del backend se mantienen para ordenamiento, pero no se muestran explícitamente en la UI actual:

- `CRITICA` → Orden 4 (más alta)
- `ALTA` → Orden 3
- `MEDIA` → Orden 2
- `BAJA` → Orden 1

El backend ordena las alertas por:
1. Prioridad (descendente)
2. Fecha de creación (descendente)

---

## Agrupación por Tiempo

Los avisos se agrupan automáticamente en:

- **Hoy**: Avisos creados el día actual
- **Anterior**: Avisos creados en días previos

### Función de Agrupación

```typescript
function getGrupo(creadoEn: string): AvisoGroup {
  const now = new Date();
  const created = new Date(creadoEn);
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const createdDate = new Date(created.getFullYear(), created.getMonth(), created.getDate());

  return createdDate.getTime() === today.getTime() ? "hoy" : "anterior";
}
```

---

## Tiempo Relativo

El tiempo relativo se calcula dinámicamente desde la fecha de creación:

| Diferencia | Formato |
|-----------|---------|
| < 1 minuto | "Hace menos de 1 min" |
| < 60 minutos | "Hace X min" |
| < 24 horas | "Hace Xh" |
| 1 día | "Hace 1 día" |
| < 7 días | "Hace X días" |
| < 30 días | "Hace X semanas" |
| ≥ 30 días | "Hace X meses" |

---

## Contadores de Tabs

Los contadores se calculan dinámicamente en tiempo real:

```typescript
const counts = {
  todos: avisos.length,
  "no-leidas": avisos.filter((aviso) => !aviso.leida).length,
  leidas: avisos.filter((aviso) => aviso.leida).length,
};
```

---

## Endpoints Utilizados

### 1. Obtener Todos los Avisos
```
GET /api/admin-hub/alerts
Query Params:
  - estado?: "PENDIENTE" | "REVISADO" | "RESUELTO" | "ANULADO"
  - tipo?: TipoAlerta
  - prioridad?: PrioridadAlerta
  - empresaId?: string
```

### 2. Marcar como Leído
```
PATCH /api/admin-hub/alerts/{id}
Body: { estado: "RESUELTO" }
```

---

## Archivos Modificados

### Frontend
1. ✅ `src/app/admin-hub/avisos/actions/avisos.actions.ts` (NUEVO)
   - Funciones de integración con API
   - Mapeo de datos backend → UI
   
2. ✅ `src/app/admin-hub/avisos/components/AvisosPageContent.tsx`
   - Reemplazado mock por llamadas a API real
   - Implementado estados de carga y error
   
3. ✅ `src/app/admin-hub/components/AdminHubTopBar.tsx`
   - Contador de avisos no leídos desde API
   
4. ✅ `src/app/admin-hub/avisos/data/mock-avisos.ts`
   - Eliminados datos mock
   - Mantenida configuración de grupos

### Backend
- ✅ Endpoint ya existente y funcional
- ✅ No requiere cambios

---

## Casos de Prueba

### CA-1: Listado desde API agrupado
✅ **VALIDADO**
- Los avisos se cargan desde `GET /api/admin-hub/alerts`
- Se agrupan correctamente por "Hoy" y "Anterior"
- Se muestran ordenados por prioridad y fecha

### CA-2: Tab "No leídas"
✅ **VALIDADO**
- Filtra avisos con `estado === PENDIENTE || estado === REVISADO`
- El contador coincide con los avisos filtrados

### CA-3: Tab "Leídas"
✅ **VALIDADO**
- Filtra avisos con `estado === RESUELTO || estado === ANULADO`
- El contador coincide con los avisos filtrados

### CA-4: Contadores en tabs
✅ **VALIDADO**
- Los contadores se calculan dinámicamente
- Coinciden con los datos reales de la API

---

## Estados de la UI

### Estado de Carga
```tsx
if (loading) {
  return <div>Cargando avisos...</div>;
}
```

### Estado de Error
```tsx
if (error) {
  return <div>{error}</div>;
}
```

### Estado Vacío
```tsx
if (groupedAvisos.length === 0) {
  return <div>No hay avisos para mostrar en esta pestaña.</div>;
}
```

---

## Notas Técnicas

1. **Cache**: Los avisos se cargan sin caché (`Cache-Control: no-store`)
2. **Refresco**: Los avisos se recargan al montar el componente
3. **Optimización**: Se puede agregar revalidación periódica si es necesario
4. **Persistencia**: El estado de leída/no leída se persiste en la base de datos

---

## Próximas Mejoras Sugeridas

1. **Revalidación automática**: Agregar polling o WebSockets para actualizaciones en tiempo real
2. **Filtros adicionales**: Por categoría, prioridad, empresa
3. **Acciones masivas**: Marcar múltiples avisos como leídos
4. **Notificaciones push**: Integrar con sistema de notificaciones del navegador
5. **Historial**: Ver avisos anulados o archivados

---

## Resumen de Validación

| Criterio | Estado | Notas |
|----------|--------|-------|
| Mapeo Backend → UI | ✅ | Implementado y documentado |
| Tabs leída/no leída | ✅ | Funcional según reglas definidas |
| Contadores dinámicos | ✅ | Calculados desde datos reales |
| Agrupación temporal | ✅ | Hoy/Anterior automático |
| URLs de acción | ✅ | Generadas según tipo de alerta |
| Sin datos mock | ✅ | Eliminados completamente |

**Estado General**: ✅ **COMPLETADO Y VALIDADO**
