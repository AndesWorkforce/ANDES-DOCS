# fix(navbar): sticky navbar + fix snap scroll chaining on Offers landing

## Resumen

Fix de la Navbar que desaparecía al navegar a la página "Open Contracts", y ajuste del hero banner de la landing de ofertas.

## Tipo de cambio

- [x] Bugfix

## Root cause

El contenedor snap (`h-screen overflow-y-scroll snap-y snap-mandatory`) de `OffersLandingPage` causaba scroll chaining hacia el body. Al hacer scroll dentro del snap container, el body se desplazaba ~85px (altura del navbar), sacándolo del viewport.

## Cambios

- **`Navbar.tsx`**: se añadió `sticky top-0 z-50` para que la Navbar nunca salga del viewport.
- **`OffersLandingPage.tsx`**: snap container usa `h-[calc(100vh-var(--navbar-height))]` y `overscroll-y-contain`.
- **`HeroSection.tsx`**: reducido de `h-screen` a `h-[60vh]`.

## Cómo probar / QA

1. Ir a `/pages/offers` sin estar autenticado.
2. Hacer scroll dentro del snap container.
3. Verificar que la Navbar permanece visible en todo momento.
4. Verificar que el hero banner se ve más compacto (60vh).

## Checklist

- [x] Build y linter pasan localmente.

## Notas para el reviewer

El `--navbar-height` está definido en `globals.css` como `105px`.

---

**Repositorio:** `CLIENT-ANDES`
