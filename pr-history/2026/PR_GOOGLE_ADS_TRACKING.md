# Feature: Google Ads Conversion Tracking Implementation

## Resumen

Implementación de seguimiento de conversiones de Google Ads para medir la efectividad de los anuncios cuando los usuarios hacen clic en botones de contacto o envían el formulario de contacto.

## Tipo de cambio

- [x] Nueva funcionalidad

## Implementación

### Script de Tracking Global

- Función helper `gtagSendEvent(url)` en el layout principal.
- Registra el evento `ads_conversion_Contact_1` antes de navegar a la página de contacto.
- Timeout de 2 segundos para garantizar envío del evento.

### Botones de Navegación a Contacto

- **"Read More"** (About Section) → navega a `/pages/contact`.
- **"Contact Us"** (Services Section) → navega a `/pages/contact`.

### Formulario de Contacto

- Tracking al envío exitoso del formulario.

## Archivos Modificados

- `src/types/gtag.d.ts` (nuevo — declaraciones TypeScript)
- `src/app/layout.tsx` (+15 líneas)
- `src/app/pages/home/components/AboutSection.tsx` (+9 líneas)
- `src/app/pages/home/components/ServicesSection.tsx` (+9 líneas)
- `src/app/pages/contact/components/ContactForm.tsx` (+5 líneas)

## Cómo Probar / QA

1. Abrir DevTools → Console → ejecutar `typeof window.gtagSendEvent` → debe retornar `"function"`.
2. DevTools → Network → filtrar por `collect`.
3. Clic en **"Read More"** (sección About) → verificar request a `google-analytics.com/g/collect` con param `en=ads_conversion_Contact_1`.
4. Enviar formulario de contacto → verificar request en Network.

## Checklist

- [x] Build y linter pasan localmente.
- [x] Sin breaking changes.
- [x] Fallback incluido: si falla el tracking, los botones funcionan normalmente.

## Notas

- **Sin costos adicionales**: el tracking es gratuito.
- **Impact en bundle**: ~2KB de JavaScript adicional.
- Datos en Google Ads aparecen después de 24-48 horas.

---

**Repositorio:** `CLIENT-ANDES`
