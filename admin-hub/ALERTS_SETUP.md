# Sistema de Alertas - Instrucciones de Configuración

Este documento describe los pasos necesarios para configurar y desplegar el nuevo sistema de alertas en el Admin Hub.

## Resumen de la Implementación

Se ha implementado un sistema completo de alertas que permite:

- Crear y gestionar alertas asociadas a diferentes entidades del sistema
- Mostrar alertas pendientes en el dashboard del Admin Hub
- Filtrar alertas por tipo, estado, prioridad, empresa, etc.
- Actualizar el estado de las alertas (PENDIENTE → REVISADO → RESUELTO)
- Ver estadísticas de alertas agrupadas por tipo

## Componentes Implementados

### Backend (API-ANDES)

1. **Modelo Prisma**: `Alerta` con relaciones a `Empresa`, `ProcesoContratacion`, `Nomina`, `IncomeVariable`, `Deduccion` y `Usuario`
2. **DTOs**: 
   - `QueryAlertsDto` - Para filtrar alertas
   - `CreateAlertDto` - Para crear alertas
   - `UpdateAlertDto` - Para actualizar alertas
   - `AlertResponseDto` - Para la respuesta de la API
3. **Service**: `AlertsService` con métodos CRUD y filtrado
4. **Controller**: `AlertsController` con endpoints REST
5. **Module**: `AlertsModule` integrado en `AdminHubModule`
6. **Tests**: `alerts.service.spec.ts` con tests unitarios

### Frontend (CLIENT-ANDES)

1. **Tipos**: Enums y interfaces TypeScript en `avisos.types.ts`
2. **Service**: `alerts.service.ts` con cliente HTTP para consumir la API
3. **Hook**: `useAlerts` y `useAlertsPendientes` con manejo de estados
4. **Componente**: `AlertsList` con estados loading/error/empty
5. **Integración**: Dashboard actualizado para mostrar alertas pendientes
6. **Tests**: `useAlerts.test.ts` con tests de integración

## Pasos para Desplegar

### 1. Ejecutar Migraciones de Prisma

```bash
cd API-ANDES

# Crear una nueva migración
npx prisma migrate dev --name add-alertas-system

# O si la base de datos ya está en producción:
npx prisma migrate deploy
```

### 2. Generar Cliente de Prisma

```bash
npx prisma generate
```

### 3. Verificar la Migración

```bash
# Verificar que las tablas se crearon correctamente
npx prisma studio
```

### 4. Reiniciar el Backend

```bash
# Detener el servidor si está corriendo
# Luego iniciar nuevamente
npm run start:dev
```

### 5. Verificar Endpoints

Los siguientes endpoints estarán disponibles:

- `GET /api/admin-hub/alerts` - Obtener todas las alertas (con filtros opcionales)
- `GET /api/admin-hub/alerts/pendientes` - Obtener solo alertas pendientes
- `GET /api/admin-hub/alerts/stats/by-type` - Obtener estadísticas por tipo
- `GET /api/admin-hub/alerts/:id` - Obtener una alerta específica
- `POST /api/admin-hub/alerts` - Crear nueva alerta
- `PATCH /api/admin-hub/alerts/:id` - Actualizar alerta
- `DELETE /api/admin-hub/alerts/:id` - Eliminar alerta

### 6. Probar en Swagger

Acceder a `http://localhost:5000/api` (o la URL de tu API) para ver la documentación interactiva de Swagger y probar los endpoints.

### 7. Frontend - Instalar Dependencias (si es necesario)

```bash
cd CLIENT-ANDES
npm install
```

### 8. Iniciar el Frontend

```bash
npm run dev
```

### 9. Verificar el Dashboard

Navegar a `/admin-hub/dashboard` para ver las alertas pendientes.

## Estructura de la Alerta

```typescript
interface Alerta {
  id: string;
  tipo: TipoAlerta; // NOMINA_PENDIENTE, VARIABLE_INGRESO_PENDIENTE, etc.
  estado: EstadoAlerta; // PENDIENTE, REVISADO, RESUELTO, ANULADO
  prioridad: PrioridadAlerta; // BAJA, MEDIA, ALTA, CRITICA
  titulo: string;
  descripcion?: string;
  empresaId?: string;
  procesoContratacionId?: string;
  nominaId?: string;
  incomeVariableId?: string;
  deduccionId?: string;
  metadata?: Record<string, unknown>;
  creadoEn: Date;
  actualizadoEn?: Date;
  resueltaEn?: Date;
  creadoPorId?: string;
  resueltoPorId?: string;
}
```

## Ejemplos de Uso

### Crear una Alerta desde el Backend

```typescript
// En cualquier servicio del backend
import { AlertsService } from './admin-hub/alerts/alerts.service';

// Inyectar el servicio
constructor(private readonly alertsService: AlertsService) {}

// Crear una alerta
await this.alertsService.create({
  tipo: TipoAlerta.NOMINA_PENDIENTE,
  prioridad: PrioridadAlerta.ALTA,
  titulo: 'Nómina de Mayo 2026 próxima a cerrar',
  descripcion: 'Quedan 3 días para cerrar la nómina',
  nominaId: 'nomina-uuid',
  procesoContratacionId: 'contrato-uuid',
});
```

### Consumir Alertas desde el Frontend

```typescript
// En cualquier componente de React
import { useAlertsPendientes } from './hooks/useAlerts';

function MyComponent() {
  const { data, loading, error, refetch } = useAlertsPendientes();

  if (loading) return <div>Cargando...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      {data.map(alert => (
        <div key={alert.id}>{alert.titulo}</div>
      ))}
    </div>
  );
}
```

## Testing

### Backend

```bash
cd API-ANDES
npm run test alerts.service.spec.ts
```

### Frontend

```bash
cd CLIENT-ANDES
npm run test useAlerts.test.ts
```

## Próximos Pasos Sugeridos

1. **Crear alertas automáticas**: Implementar jobs que creen alertas automáticamente cuando:
   - Una nómina esté próxima a cerrar
   - Haya variables de ingreso pendientes de aprobar
   - Haya deducciones sin procesar
   - Etc.

2. **Notificaciones en tiempo real**: Integrar WebSockets o Server-Sent Events para notificaciones en tiempo real

3. **Filtros avanzados**: Agregar más filtros en el dashboard (por fecha, por usuario, etc.)

4. **Dashboard de métricas**: Crear gráficos y estadísticas de alertas

5. **Acciones rápidas**: Agregar botones para resolver alertas directamente desde el dashboard

## Soporte

Si encuentras algún problema durante el despliegue, verifica:

1. Que la base de datos esté accesible
2. Que las variables de entorno estén configuradas correctamente
3. Que no haya conflictos de puertos
4. Que los logs del backend no muestren errores

## Archivos Creados/Modificados

### Backend
- `API-ANDES/prisma/schema.prisma` (modificado)
- `API-ANDES/src/admin-hub/alerts/alerts.module.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/alerts.service.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/alerts.controller.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/alerts.service.spec.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/dto/query-alerts.dto.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/dto/create-alert.dto.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/dto/update-alert.dto.ts` (nuevo)
- `API-ANDES/src/admin-hub/alerts/dto/alert-response.dto.ts` (nuevo)
- `API-ANDES/src/admin-hub/admin-hub.module.ts` (modificado)

### Frontend
- `CLIENT-ANDES/src/app/admin-hub/dashboard/types/avisos.types.ts` (modificado)
- `CLIENT-ANDES/src/app/admin-hub/dashboard/services/alerts.service.ts` (nuevo)
- `CLIENT-ANDES/src/app/admin-hub/dashboard/hooks/useAlerts.ts` (nuevo)
- `CLIENT-ANDES/src/app/admin-hub/dashboard/hooks/useAlerts.test.ts` (nuevo)
- `CLIENT-ANDES/src/app/admin-hub/dashboard/components/AlertsList.tsx` (nuevo)
- `CLIENT-ANDES/src/app/admin-hub/dashboard/page.tsx` (modificado)
