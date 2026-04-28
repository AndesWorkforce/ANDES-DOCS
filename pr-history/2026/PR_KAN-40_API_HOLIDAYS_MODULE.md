# Resumen

Implementación del módulo de gestión de días festivos (Holidays) con operaciones CRUD completas, paginación y filtrado por país para mostrar calendarios personalizados según la ubicación del usuario.

## Tipo de cambio

- [x] Nueva funcionalidad

## Issue relacionada

`KAN-40` — Calendar bonifications

## Descripción detallada

### Modelo de datos

Nuevo modelo `Holiday` en Prisma:
- `id` (UUID), `nombre`, `dia`, `mes`, `pais`, `codigoPais`, `activo`, `fechaCreacion`.

### Endpoints

**Protegidos (SuperAdmin):**
- `POST /holidays` — Crear festivo
- `GET /holidays` — Listar con paginación
- `GET /holidays/:id` — Obtener uno
- `PATCH /holidays/:id` — Actualizar
- `DELETE /holidays/:id` — Eliminar

**Públicos:**
- `GET /holidays/countries` — Lista de países con holidays
- `GET /holidays/by-country/:countryName` — Festivos por país

### Datos iniciales

`sql/predeploy/insert_holidays.sql` — Días festivos para 10 países latinoamericanos (Colombia, México, Argentina, Chile, Perú, Ecuador, Venezuela, Uruguay, Paraguay, Bolivia).

## Cómo probar / QA

1. Ejecutar migración: `pnpm prisma migrate dev`.
2. Cargar datos iniciales: ejecutar `sql/predeploy/insert_holidays.sql`.
3. `GET /holidays/countries` → debe retornar array de países únicos.
4. `GET /holidays/by-country/Colombia` → festivos de Colombia del año actual.
5. Solo SuperAdmin puede crear/editar/eliminar holidays (401 para otros roles).

## Checklist

- [x] Concurrency, performance y edge cases revisados.
- [ ] Tests unitarios/integ. pendientes.
- [x] Documentación Swagger actualizada.
- [x] El build y linter pasan localmente.

---

**Repositorio:** `API-ANDES`  
**Ticket:** `KAN-40`
