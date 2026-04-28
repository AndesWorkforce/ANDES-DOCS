# feat(about): Pet Family infinite carousel redesign

## Resumen

Rediseño completo de la sección **Pet Family** en la página About Us. Se reemplazó el grid estático de tarjetas por un **carrusel infinito con animación de deslizamiento** (derecha → izquierda), imágenes circulares y soporte responsivo.

## Tipo de cambio

- [x] Nueva funcionalidad

## Descripción detallada

### Lógica del carrusel

- Técnica de clones: `[last N pets] + [real pets] + [first N pets]`.
- `trackIndex` maneja la posición en el array extendido.
- `handleTransitionEnd` detecta el extremo y teleporta sin parpadeo desactivando la transición CSS.
- Autoplay cada 3.5 segundos, pausado al hacer hover.

### Responsividad

- 5 tarjetas en desktop (≥ 1024px), 3 en tablet, 2 en mobile.

### Diseño

- Imágenes circulares (`rounded-full`) con ring `#0097B2`.
- Botones Prev/Next flotantes con hover en `#0097B2`.
- Dots indicadores: el activo se expande en píldora azul.

## Cómo probar / QA

1. Ir a `/pages/about` → bajar hasta **Our Pet Family**.
2. Verificar autoplay cada ~3.5s sin salto brusco al llegar al extremo.
3. Verificar responsive: 2 tarjetas mobile, 3 tablet, 5 desktop.
4. Hover → autoplay se detiene; al salir → se reanuda.
5. Click en dots → navega a la mascota correspondiente.

## Checklist

- [x] Performance y edge cases revisados (loop infinito, resize, cleanup de interval).
- [x] Build y linter pasan localmente (0 errores TypeScript).

---

**Repositorio:** `CLIENT-ANDES`
