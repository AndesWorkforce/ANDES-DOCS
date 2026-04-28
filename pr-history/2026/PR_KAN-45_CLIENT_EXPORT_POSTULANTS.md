# feat(KAN-45): Export to Excel — Postulants page

## Resumen

Se añade un botón **"Export to Excel"** en la página de Postulants (`/admin/dashboard/postulants`) que permite al administrador descargar en un archivo `.xlsx` la lista completa de postulantes aplicando los filtros activos, sin limitarse a la página visible en pantalla.

## Tipo de cambio

- [x] Nueva funcionalidad

## Issue relacionada

`KAN-45`

## Descripción detallada

**`src/app/admin/dashboard/postulants/page.tsx`**

- Se añade `isExporting` para manejar el loading durante la exportación.
- `handleExportExcel` llama a `getApplicants(1, 9999, search, stageFilter, applicantStatusFilter)` para obtener **todos los postulantes** que coincidan con los filtros activos.
- Genera `postulants.xlsx` con los campos: Full Name, Email, Phone, Country, Active, Classification, Rating (Stars), Stage, Application Status, Position, Preliminary Interview.
- Botón **"Export to Excel"** con estado `disabled` + texto `"Exporting..."` durante la descarga.

## Cómo probar / QA

1. Ir a `/admin/dashboard/postulants`.
2. (Opcional) Aplicar filtros.
3. Hacer clic en **"Export to Excel"**.
4. Verificar que se descarga `postulants.xlsx` con todos los postulantes (no solo la página visible).
5. Verificar que las columnas son correctas.

## Checklist

- [x] Concurrency, performance y edge cases revisados.
- [x] El build y linter pasan localmente.

## Notas para el reviewer

- El límite de `9999` es suficiente para el volumen actual. Se puede migrar a un endpoint dedicado si el volumen crece.
- El package `xlsx` ya estaba instalado como dependencia del proyecto (v0.18.5).

---

**Repositorio:** `CLIENT-ANDES`  
**Ticket:** `KAN-45`
