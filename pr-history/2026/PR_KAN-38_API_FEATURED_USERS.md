# Resumen

Agrega soporte para perfiles destacados (`isFeatured`) en el modelo `Usuario`, exponiendo endpoints públicos y de administración para gestionar qué candidatos aparecen en la sección de talento featured de la página de ofertas.

## Tipo de cambio

- [x] Nueva funcionalidad

## Issue relacionada

`KAN-38`

## Descripción detallada

Se añadió el campo `isFeatured: Boolean @default(false)` al modelo `Usuario` en Prisma y se implementaron dos nuevos endpoints en el módulo `usuarios`:

- `GET /usuarios/featured` — público, retorna la lista de usuarios con `isFeatured: true` junto con su posición y empresa cliente (obtenidas de su última postulación aceptada con contrato activo).
- `PATCH /usuarios/:id/toggle-featured` — protegido con JWT, solo accesible para roles `ADMIN`, `EMPLEADO_ADMIN` y `ADMIN_RECLUTAMIENTO`. Alterna el estado `isFeatured` del usuario.

## Cómo probar / QA

1. Aplicar la migración: `npx prisma migrate dev`.
2. Marcar un usuario como featured desde el panel admin (toggle).
3. Llamar `GET /usuarios/featured` sin token y verificar que retorna los usuarios marcados con `position` y `client` correctamente mapeados.
4. Intentar llamar `PATCH /usuarios/:id/toggle-featured` sin token → debe retornar `401`.
5. Llamar con token de rol `CANDIDATO` → debe retornar `401`.
6. Llamar con token de `ADMIN` → debe alternar `isFeatured` y retornar el nuevo estado con mensaje.

## Checklist

- [x] Concurrency, performance y edge cases revisados si aplica.
- [ ] Tests unitarios/integ. añadidos o actualizados cuando corresponda.
- [x] El build y linter pasan localmente.

## Notas para el reviewer

- La migración solo agrega una columna con valor por defecto, sin romper datos existentes.
- El endpoint `GET /usuarios/featured` no requiere autenticación — revisar que no exponga datos sensibles (solo retorna `id`, `nombre`, `apellido`, `pais`, `paisImagen`, `fotoPerfil`, `position`, `client`).

---

**Repositorio:** `API-ANDES`  
**Ticket:** `KAN-38`
