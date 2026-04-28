# feat: Home Hero — CTA redesign, dual buttons & logo update

## Resumen

Actualización de la sección Hero de la home: nuevo logo blanco, redirección corregida del CTA principal y adición de un segundo botón para candidatos. Además se actualizó un stat card en la sección "Why Choose Us".

## Cambios

### `src/app/pages/home/components/HeroSection.tsx`

- **Logo:** reemplazado `/logo-andes.png` por `/LOGO_ANDES_BLANCO_TRANSPARENTE.png` (280×70px, fill + object-contain).
- **"Find Talent Now":** redirige ahora a `/pages/services` (antes apuntaba a `/pages/offers`).
- **"Join Our Team"** *(nuevo botón)*: redirige a `/pages/offers`, diseñado con fondo blanco.
- Contenedor de CTAs: `flex-wrap` con `gap-3` para soportar ambos botones en cualquier resolución.

### `src/app/pages/home/components/PartnersSection.tsx`

- Stat card actualizado: `"3% — Quality Assured"` → `"10–15% — Top of talent"` con descripción más detallada.

## Resultado visual

| | Antes | Después |
|---|---|---|
| **CTA** | 1 botón → `/pages/offers` | 2 botones: **Find Talent Now** → `/pages/services` / **Join Our Team** → `/pages/offers` |
| **Logo** | Color `180×46px` | Blanco transparente `280×70px` |
| **Stat card** | `3% — Quality Assured` | `10–15% — Top of talent` |

---

**Repositorio:** `CLIENT-ANDES`
