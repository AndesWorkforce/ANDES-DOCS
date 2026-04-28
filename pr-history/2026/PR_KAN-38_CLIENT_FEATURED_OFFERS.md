# Resumen

Rediseño de la sección pública de talento destacado en la página de ofertas (Figma) y migración del panel de administración de perfiles featured desde el dashboard principal hacia la sección de configuración del superAdmin.

## Tipo de cambio

- [x] Nueva funcionalidad
- [x] Refactor

## Issue relacionada

`KAN-38`

## Descripción detallada

### 1. Rediseño de `FeaturedTalentSection` (página pública de ofertas)

Se aplicó el diseño exacto de Figma a las tarjetas del carrusel de talento:

- Tarjetas con `border`, `rounded-[10px]`, `p-[15px]`, imagen `150×150px` con `rounded-[5px]`.
- Layout de 3 tarjetas visibles simultáneamente usando `flex-1 min-w-[400px]`.
- Texto con `break-words` para evitar desbordamiento.
- Resolución automática de banderas faltantes: si `paisImagen` es `null` en la BD, se consulta `restcountries.com/v3.1/all?fields=name,flags` al cargar y se mapea por nombre de país.

### 2. Migración del dashboard de perfiles featured a superAdmin/settings

- Se extrajo la UI de gestión de featured a un componente standalone `FeaturedProfilesManager`.
- Se integró en `superAdmin/settings/page.tsx` como nueva sección en el sidebar (junto a Holidays).
- Se eliminó el tab "Featured" del `TabsNavigation` del dashboard principal.
- La ruta `/admin/dashboard/featured-profiles` ahora redirige a `/admin/superAdmin/settings`.
- La lista de candidatos muestra primero los que ya están marcados como featured.

## Cómo probar / QA

1. Ir a la página pública de ofertas → verificar que el carrusel muestra 3 tarjetas con el diseño correcto y banderas de todos los países.
2. Ir a `/admin/superAdmin/settings` → verificar que aparece el ítem "Featured Profiles" en el sidebar.
3. Activar/desactivar un candidato como featured → verificar que sube al tope de la lista.
4. Ir a `/admin/dashboard/featured-profiles` → debe redirigir a `/admin/superAdmin/settings`.
5. Verificar que el tab "Featured" ya no aparece en la navegación del dashboard.

## Checklist

- [x] Concurrency, performance y edge cases revisados si aplica.
- [x] El build y linter pasan localmente.

## Notas para el reviewer

- La llamada a `restcountries.com` se hace una sola vez al montar el componente, solo si hay perfiles con `paisImagen: null`.
- `FeaturedProfilesManager` usa las mismas server actions existentes (`toggleFeatured`, `getFeaturedCandidates`), sin cambios en la API.

---

**Repositorio:** `CLIENT-ANDES`  
**Ticket:** `KAN-38`
