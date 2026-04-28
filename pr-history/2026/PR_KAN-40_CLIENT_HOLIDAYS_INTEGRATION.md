# Resumen

Corrección del idioma de los meses en el dashboard de holidays (español → inglés) e integración completa de la API de holidays en la página de bonifications para mostrar días festivos personalizados por país.

## Tipo de cambio

- [x] Bugfix
- [x] Nueva funcionalidad

## Issue relacionada

`KAN-40` — Calendar bonifications

## Descripción detallada

### 1. Corrección de idioma en HolidaysManager

Cambio del locale de `"es-ES"` a `"en-US"` en la visualización de meses.

### 2. Integración de Holidays API en Bonifications

**`holidays.actions.ts`**
- Nueva función `getHolidaysByCountry(countryName: string)`.
- Consume `GET /holidays/by-country/:countryName`.

**`bonifications/page.tsx`**
- Reemplazado el TODO con llamada real a la API.
- Carga de holidays automática al montar el componente, filtrado por país del usuario.
- Construye la fecha desde `holiday.mes` y `holiday.dia` (no usa `holiday.fecha` que no existe).
- Formato: `'en-US'`, "Month DD".

### Estados manejados

- Loading spinner.
- No autenticado: mensaje para login.
- Sin país configurado: mensaje para completar perfil.
- Con holidays: tabla completa.
- País sin holidays disponibles: mensaje informativo.

## Cómo probar / QA

1. Login con usuario con `pais: "Colombia"` → navegar a `/bonifications`.
2. Verificar que carga holidays de Colombia con formato "January 01".
3. Login con usuario sin país → debe mostrar mensaje de perfil incompleto.
4. Verificar tabla de admin (`/admin/superAdmin/settings`) → meses en inglés.

## Checklist

- [x] Concurrency, performance y edge cases revisados.
- [x] El build y linter pasan localmente.

---

**Repositorio:** `CLIENT-ANDES`  
**Ticket:** `KAN-40`
