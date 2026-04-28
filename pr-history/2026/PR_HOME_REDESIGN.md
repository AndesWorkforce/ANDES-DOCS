# feat(home): rediseño completo de la página de inicio

## Resumen

Rediseño completo de todas las secciones de la home page (`/pages/home`) siguiendo los diseños de Figma. Se reemplazaron los componentes existentes por implementaciones fieles al brand de Andes Workforce.

## Tipo de cambio

- [x] Nueva funcionalidad
- [x] Refactor

## Secciones rediseñadas

- **HeroSection**: Fondo navy `#00224d`, logo a color, headline con palabras en teal `#0097b2`.
- **PartnersSection**: Carrusel de logos con scroll infinito (18s), 5 tarjetas de estadísticas.
- **PersonnelTypes**: Fondo navy, 3 tarjetas blancas con `hover:scale-105`, iconos GIF desde S3.
- **TestimonialsSection**: Carrusel paginado de 6 testimonios (3 por slide), autoplay pausado al hover.
- **AboutSection**: Fondo navy, 2 columnas, crossfade automático entre imágenes cada 4s.
- **CTASection** *(nuevo)*: Tarjeta navy `rounded-[50px]`, botón "Contact Us" teal.

## Cómo probar / QA

1. Ingresar a `/pages/home`.
2. Verificar todas las secciones (Hero, Partners, PersonnelTypes, Testimonials, About, CTA).
3. En **TestimonialsSection**: hover → el texto se expande y el autoplay se detiene.
4. En **AboutSection**: esperar 4s → crossfade de imagen.
5. Verificar responsividad en mobile (breakpoint `md`).

## Checklist

- [x] Build y linter pasan localmente.
- [x] Componentes `"use client"` donde se requiere interactividad.
- [x] Sin imports no utilizados.

## Notas para el reviewer

- Las dos imágenes de `AboutSection` apuntan actualmente a la misma URL (pendiente segunda imagen real en S3).
- Los `@keyframes` en `tailwind.config.ts` se mantienen aunque actualmente no se usan — los iconos son GIFs auto-animados.

---

**Repositorio:** `CLIENT-ANDES`
