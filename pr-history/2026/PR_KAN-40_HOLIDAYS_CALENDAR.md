# Resumen

Implementación de un calendario de días festivos por país en la página de bonificaciones usando el paquete `date-holidays`, mostrando automáticamente los holidays del país del usuario autenticado. Se reemplazó un archivo de datos estáticos de 282 líneas por una solución escalable.

## Tipo de cambio

- [x] Nueva funcionalidad

## Issue relacionada

`KAN-40` — Calendar bonifications

## Descripción detallada

### Paquete `date-holidays` (v3.26.8)

- Soporte para 199 países automáticamente.
- Cálculo automático de feriados móviles (Semana Santa, etc.).
- Incluye días sustitutos cuando feriados caen en fin de semana.
- Todo funciona offline, sin APIs de terceros.

### Nuevo servicio `src/services/holidays.service.ts`

- Mapeo de nombres de países en español a códigos ISO.
- `getHolidaysForCountry()` → solo feriados públicos del año actual.
- `formatHolidayDate()` para fechas legibles.

### Cambios en `bonifications/page.tsx`

- Convertida a Client Component.
- Título: "Table of Additional Incentives for Contractors" → **"Incentives & Holidays"**.
- Tabla con encabezado turquesa (`#0097B2`) y nombre del país + año.
- Formato de fechas: "Month DD, YYYY".
- Ordenamiento cronológico automático.
- Eliminado `src/data/holidays.ts` (282 líneas de datos hardcoded).

## Cómo probar / QA

1. Login con usuario de Colombia → `/bonifications`.
2. Verificar tabla "Colombia - Public Holidays [año]" con 18-19 festivos.
3. Probar otros países (Argentina, Perú, México, Venezuela, EE.UU.).
4. Verificar estados: Loading, sin login, sin país, país no soportado.

## Consideraciones de bundle

- `date-holidays` agrega ~1-2MB después de tree-shaking.
- No hay llamadas HTTP adicionales en runtime.

## Checklist

- [x] Performance y edge cases revisados.
- [x] Build y linter pasan localmente.
- [x] Código no utilizado eliminado.

---

**Repositorio:** `CLIENT-ANDES`  
**Ticket:** `KAN-40`
