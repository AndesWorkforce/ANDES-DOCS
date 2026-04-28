# Resumen

Rediseño completo del navbar implementando un header de dos niveles basado en el diseño de Figma, mejorando la experiencia visual y de navegación en desktop y mobile.

## Tipo de cambio

- [x] Nueva funcionalidad

## Issue relacionada

`KAN-38`

## Descripción detallada

### Header de dos niveles

**Top Header (Header 2)** — Visible solo en desktop:
- Redes sociales (Facebook, Instagram, LinkedIn) alineadas a la izquierda.
- Información de contacto (teléfonos y email) alineada a la derecha.
- Altura de 25px con borde inferior sutil.

**Main Header** — Navegación principal:
- Logo a la izquierda, navegación centrada, botones de auth a la derecha.
- Borde inferior de 3px para página activa.
- Altura responsiva: 45px (mobile) / 60px (desktop).

### Mejoras de diseño

- Color de marca `#0097B2` en iconos, links activos y botones.
- Botones con bordes redondeados (`rounded-[15px]`).
- Sombra del header: `shadow-[0px_4px_4px_0px_rgba(210,210,210,0.25)]`.
- Navegación mobile con scroll horizontal optimizado.

### Funcionalidad preservada

- Toda la lógica de autenticación existente.
- Menús desplegables para usuarios.
- Sidebar móvil.
- Gestión de contratos activos.
- Rutas diferenciadas por roles.

## Cómo probar / QA

**Desktop:**
1. Verificar que el top header muestra redes sociales a la izquierda e info de contacto a la derecha.
2. Navegar entre páginas y confirmar borde inferior azul (3px) en página activa.

**Mobile:**
1. Confirmar que el top header NO es visible.
2. Verificar scroll horizontal en la navegación mobile.
3. Página activa con fondo azul `#0097B2`.

## Checklist

- [x] Concurrency, performance y edge cases revisados.
- [x] El build y linter pasan localmente.

---

**Repositorio:** `CLIENT-ANDES`  
**Ticket:** `KAN-38`
