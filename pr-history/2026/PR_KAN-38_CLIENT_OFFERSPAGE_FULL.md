# Resumen

Implementación completa de la nueva experiencia pública de la página de ofertas para usuarios no autenticados, incluyendo landing page con scroll snapping, rediseño del Footer, migración del panel de Featured Profiles al área de superAdmin/settings, y refactor modular de la página de ofertas.

## Tipo de cambio

- [x] Nueva funcionalidad
- [x] Refactor

## Issue relacionada

`KAN-38`

## Descripción detallada

### 1. Landing page pública en `/pages/offers` para usuarios no autenticados

Se creó una landing page completa con scroll-snapping (`snap-y snap-mandatory`) compuesta por 4 secciones independientes:

- **`HeroSection`**: sección hero con CTA que hace scroll suave hasta el formulario de contacto.
- **`FeaturedTalentSection`**: carrusel de candidatos destacados con diseño Figma.
- **`ContactFormSection`**: formulario de contacto embebido.
- **`BenefitsSection`**: sección de beneficios con CTA al formulario.

### 2. Refactor de `offers/page.tsx` — split authenticated / unauthenticated

- Los usuarios no autenticados ven `<OffersLandingPage />`.
- Los usuarios autenticados ven `<AuthenticatedOffersPage />` (lógica existente extraída a componente interno).

### 3. Rediseño del `Footer`

- Fondo `#0097B2`, layout en 3 columnas.
- Nuevo prop `forceRender?: boolean` para el contenedor snap.

### 4. Migración del panel de Featured Profiles a `superAdmin/settings`

- `FeaturedProfilesManager` como componente standalone reutilizable.
- Integrado en `superAdmin/settings/page.tsx`.

## Cómo probar / QA

1. **Usuario no autenticado** → ir a `/pages/offers`. Debe mostrar la landing page con 4 secciones snap.
2. Hacer clic en CTAs → debe hacer scroll suave hasta `ContactFormSection`.
3. **Usuario autenticado** → ir a `/pages/offers`. Debe seguir mostrando el sistema de búsqueda de ofertas existente sin cambios.
4. Ir a `/admin/superAdmin/settings` → verificar "Featured Profiles" en el sidebar.
5. Verificar Footer en cualquier página pública — nuevo diseño con fondo azul.

## Checklist

- [x] Concurrency, performance y edge cases revisados.
- [x] El build y linter pasan localmente.
- [x] Archivos y código no utilizado eliminado.

---

**Repositorio:** `CLIENT-ANDES`  
**Ticket:** `KAN-38`  
**Closes KAN-38**
