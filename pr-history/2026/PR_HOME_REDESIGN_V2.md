# feat(home): rediseño visual home page — nuevo estilo de marca

## Resumen

Segunda iteración del rediseño de la home page (`/pages/home`) siguiendo los diseños actualizados de Figma (`4lJ1U3FMJcZK4oCAISr9lw`). Se actualizaron los colores, fondos con imágenes S3, overlay teal, y la paleta del footer para alinear toda la home con el nuevo estilo de marca.

## Tipo de cambio

- [x] Nueva funcionalidad
- [x] Refactor visual / rediseño

## Descripción detallada

### ¿Qué se implementó?

Rediseño de 5 componentes de la home más el Footer global, pasando del esquema de fondo navy oscuro (`#00224d`) a un sistema de fondos con imágenes reales y overlays teal, y del footer cyan a fondo blanco.

### Secciones / componentes modificados

#### `HeroSection.tsx`
- Fondo blanco con imagen derecha (`andes_hero_home.jpg`) desplazada 80px a la derecha.
- Gradiente blanco→transparente ajustado (`2% / 10% / 18%`) para exponer más imagen.
- Overlay cyan sutil en el lado derecho (`rgba(34,188,216,0.40)`).
- Logo: `/logo-andes.png` (versión a color), 175×66.
- Headline 52px Bold `#343434` con acentos `#0097b2` en "top talent" / "Latin America".
- Botones con `rounded-[20px]`, `px-[25px] py-[12px]`, 20px SemiBold.

#### `PersonnelTypes.tsx`
- Fondo: imagen S3 `modern-equipped-computer-lab+(1)a.jpg` + overlay `linear-gradient(180deg, rgba(0,80,100,0.55) 0%, rgba(0,151,178,0.55) 100%)`.
- 3 tarjetas blancas `h-[300px]`, `rounded-[20px]`, `gap-[50px]`, `hover:scale-[1.03]`.
- Botón "Read More": bg blanco, texto `#0097b2`, `hover:bg-gray-200`.

#### `AboutSection.tsx`
- Fondo: imagen S3 `88a77507bfcfb701f5c0eb2d264b3d1a8ed3a54c.jpg` + overlay `linear-gradient(180deg, rgba(31,89,101,0.85) 0%, rgba(0,80,100,0.85) 100%)`.
- Título: `34px` Bold blanco.
- Párrafo: `17px/28px` blanco justificado.
- Botón "Read More": bg blanco, texto `#0097b2`, `hover:bg-gray-100`.
- Carrusel de imágenes con crossfade (4s) conservado intacto.
- Padding: `px-4 md:px-8`, max-width `1400px`, gap texto-imagen `80px` md.

#### `CTASection.tsx`
- Fondo: imagen S3 `b704eba031a01681d8957203b6efbd28aefd1def.jpg` + overlay `rgba(193,223,228,0.58)`.
- Tarjeta `rounded-[50px]` con contenido sobre fondo semi-transparente.
- Título: `#336e79` 40px Bold.
- Botón "Contact Us": bg `#336e79`, texto blanco, 22px Medium.

#### `Footer.tsx`
- Fondo cambiado de `bg-[#0097b2]` (cyan) → `bg-white` con sombra `0px 0px 10px 1px #d2d2d2`.
- Logo: `/logo-andes.png` (a color) en lugar del blanco transparente.
- Textos (descripción, headings, links): `#343434`.
- Iconos sociales (Facebook, Instagram, LinkedIn, TikTok): gris `#666666`.
- Iconos de contacto (Phone, Mail): cyan `#0097b2`.
- Hover en links: `#0097b2`.

## Archivos principales modificados

| Archivo | Cambio |
|---|---|
| `src/app/pages/home/components/HeroSection.tsx` | Imagen desplazada, gradiente ajustado |
| `src/app/pages/home/components/PersonnelTypes.tsx` | Bg imagen + teal overlay, hover botón |
| `src/app/pages/home/components/AboutSection.tsx` | Bg imagen + teal overlay, textos y espaciado |
| `src/app/pages/home/components/CTASection.tsx` | Bg imagen + overlay claro, colores teal oscuro |
| `src/app/components/Footer.tsx` | Bg blanco, logo a color, iconos gris |

## Cómo probar / QA

1. Ingresar a `/pages/home`.
2. Verificar **HeroSection**: imagen visible a la derecha, gradiente suave, logo a color.
3. Verificar **PersonnelTypes**: imagen de fondo con overlay teal, 3 tarjetas blancas, hover en cards y botón.
4. Verificar **AboutSection**: imagen de fondo con overlay teal oscuro, crossfade automático de imágenes cada 4s.
5. Verificar **CTASection**: imagen de fondo con overlay claro, título y botón en teal oscuro.
6. Verificar **Footer**: fondo blanco, logo a color, iconos sociales grises.
7. Revisar responsividad en mobile (`md` breakpoint).

## Checklist

- [x] Los commits siguen la [guía de commits](../../commit-guide/COMMIT_GUIDE.md) del equipo.
- [x] Build y linter pasan localmente.
- [x] Sin imports no utilizados.
- [x] Imágenes con `next/image` donde aplica, rutas S3 válidas.
- [x] Componentes `"use client"` donde se requiere interactividad.

## Notas para el reviewer

- Las imágenes de fondo se sirven desde S3 vía `style.backgroundImage` en `AboutSection` y `CTASection` (no usan `next/image`) para permitir el overlay CSS sobre ellas.
- El carrusel de `AboutSection` queda intacto (lógica de crossfade con `useState`/`useEffect`).
- El footer aplica a todas las páginas — revisar que el contraste sea correcto en el resto de rutas.

## Capturas (si aplica)

_Ver diseños de referencia en Figma: [node 2562:783 (About)](https://www.figma.com/design/4lJ1U3FMJcZK4oCAISr9lw?node-id=2562-783), [node 2562:803 (CTA)](https://www.figma.com/design/4lJ1U3FMJcZK4oCAISr9lw?node-id=2562-803), [node 2562:782 (Footer)](https://www.figma.com/design/4lJ1U3FMJcZK4oCAISr9lw?node-id=2562-782)._

---

**Repositorio:** `CLIENT-ANDES`
**Rama:** `feat/home-redesign-v2`
