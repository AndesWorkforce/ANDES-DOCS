# Fix: Join Our Team section redesign + navbar spacing

## Resumen

Actualización de landing "Join Our Team" según diseño de Figma + corrección de navbar fixed que cubría contenido.

## Tipo de cambio

- [x] Bugfix
- [x] Nueva funcionalidad

## Issue relacionada

[Figma Design](https://www.figma.com/design/4lJ1U3FMJcZK4oCAISr9lw/%F0%9F%9A%A6-Web-Andes-Workforce?node-id=3119-3625)

## Cambios principales

### Join Our Team Landing
- **Hero section**: reposicionado más abajo (`items-end` + padding ajustado)
- **Stats bar**: 
  - "Available Roles" → "Professionals Hired"
  - "Salary Range" → "Monthly Salary Range"
  - Formato: "$1K - $3K"
- **"How It Works"**: Iconos → Números circulares (01-04)
  - Círculos 73px, bg `#DFFAFF`, border `#0097B2`
  - Step 3: "Browse Client Contracts" → "Browse Open Contracts"
- **Copy updates**: CTAs, subtítulos y textos según Figma

### Navbar Spacing Fix
- **Root cause**: `position: fixed` cubría contenido de páginas
- **Solución**: Espaciador condicional (70px mobile / 85px desktop)
  - Solo se renderiza cuando navbar es visible
  - Desaparece en rutas excluidas (login, dashboards)

## Cómo probar / QA

1. `/pages/offers`: Verificar diseño según Figma
2. Páginas con navbar: Sin overlap de contenido
3. Páginas sin navbar: Sin espacios en blanco extras
4. Responsive: mobile, tablet, desktop

## Archivos modificados
- `src/app/components/Navbar.tsx` (+3 líneas)
- `src/app/pages/offers/components/JobSeekerLandingPage.tsx` (~50 líneas)
- `src/app/layout.tsx` (-1 línea)

## Checklist

- [x] Build y linter OK
- [x] Diseño alineado con Figma
- [x] Probado responsive
- [x] Verificado spacing en todas las páginas

---

**Repo:** `CLIENT-ANDES` | **Branch:** `feat-joinourteam` | **Fecha:** 2026-06-23
