# feat(offers): static featured talent cards on landing page

## Resumen

Se reemplaza la sección "Meet Our Featured Talent" de la landing de Offers para mostrar **perfiles curados manualmente** en lugar de depender exclusivamente de la API de featured profiles. Además se corrige el layout de cada tarjeta para alinearlo al diseño en Figma.

## Tipo de cambio

- [x] Nueva funcionalidad

## Descripción detallada

### `FeaturedTalentSection.tsx`

- **`STATIC_TALENT[]`** — array con 6 perfiles iniciales curados.
- **API desactivada temporalmente** — `getFeaturedProfiles()` no se llama por el momento. Fácil de reactivar.
- **Layout de tarjeta** (alineado a Figma):
  - Nombre (bold) → País con bandera debajo.
  - Profesión en gris separado.
  - Puesto (azul) + Empresa (gris) agrupados al final.
- **Avatar** aumentado a `150×150px` mobile / `190×190px` sm+.

## Cómo probar / QA

1. Ir a `/pages/offers` **sin sesión iniciada** → debe aparecer la `OffersLandingPage`.
2. Scroll hasta **"Meet Our Featured Talent"** → verificar 6 tarjetas con nombre, país, profesión, puesto y empresa.
3. Verificar que el marqée se pausa al hover.
4. Verificar responsive: 1 tarjeta mobile, 2 tablet, 3 desktop.

## Checklist

- [x] Build y linter pasan localmente.

## Notas para el reviewer

- Las URLs de `fotoPerfil` deben obtenerse de la DB y pegarse en `STATIC_TALENT`.
- Para reactivar la API basta con volver a incluir el bloque de `getFeaturedProfiles`.

---

**Repositorio:** `CLIENT-ANDES`
