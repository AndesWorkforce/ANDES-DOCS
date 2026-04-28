# fix: Mobile Responsiveness & Carousel Animation — Offers Landing Page

## Resumen

Fix de todos los problemas de responsividad mobile en las 4 secciones de la landing de Offers, introducción de un marquee CSS infinito para el carrusel de Featured Talent, y consistencia de altura entre secciones para el snap-scroll.

## Tipo de cambio

- [x] Bugfix
- [x] Mejora de UI / Responsividad

## Cambios por archivo

### `OffersLandingPage.tsx`
- `min-h-[60vh] md:h-[70vh] overflow-hidden` en cada snap wrapper.
- **Fix navbar desaparece al click en "Contact Us"**: `scrollIntoView()` fue reemplazado por `useRef` al container + `container.scrollTo()` para que solo el inner container haga scroll.

### `HeroSection.tsx`
- Altura: `h-[70vh]` → `h-full`.
- Título: `text-[48px]` → `text-[28px] sm:text-[36px] md:text-[48px]`.
- Buttons `flex-wrap` + `gap-3`.

### `FeaturedTalentSection.tsx`
- **Marquee CSS `@keyframes`** reemplazó el carrusel con `setInterval` — más simple y sin jitter.
- Cards: `flex-col` mobile → `sm:flex-row` tablet/desktop.
- `ProfileAvatar`: tamaños responsivos con Tailwind en lugar de inline styles.

### `ContactFormSection.tsx`
- Layout: `flex-row` → `flex-col md:flex-row`.
- Imagen izquierda: `hidden md:block`.

### `BenefitsSection.tsx`
- Layout: `flex-row` → `flex-col md:flex-row`.
- Título: `text-[40px]` → `text-[28px] sm:text-[34px] md:text-[40px]`.

## Checklist

- [x] Build y linter pasan localmente.

---

**Repositorio:** `CLIENT-ANDES`
