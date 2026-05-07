# [FEATURE] Add Image Use Authorization annex template

## Resumen

Nuevo template de anexo **"IMAGE USE AUTHORIZATION"** en el portal de contratación. Permite al administrador enviar a contratistas el documento de autorización de uso de imagen (fotos/videos) directamente desde el modal de envío de anexos, siguiendo exactamente el mismo flujo que los anexos existentes.

## Ticket relacionado

`KAN-100` — Image use authorization annex  
`RM-91` — Offers landing page copy update

## Tipo de cambio

- [x] Nueva funcionalidad
- [x] Corrección menor (fix logo en templates existentes)

## Descripción detallada

### ¿Qué se implementó?

**Nuevo template PDF** (`ImageUseAuthorizationAnnexPDF.tsx`):
- Componente React PDF con el texto legal completo del documento "IMAGE USE AUTHORIZATION" según el Word original.
- Variables dinámicas: `nombreCompleto` (bold en el texto) y `cedula` (bold en el texto).
- Logo de Andes centrado en el header, igual que los demás templates.
- Sin firma embebida — el campo de firma lo agrega ESIGN dinámicamente.

**Modal de envío actualizado** (`SendAnnexModal.tsx`):
- Nueva entrada en el array `contractTemplates` con id `image-use-authorization`.
- Categoría: `Compliance`. Variables: `nombreCompleto`, `correoElectronico`, `cedula`.
- Caso agregado en el `useMemo` del preview y en el handler de envío.

**Fix logo en templates existentes**:
- `ComplianceDeclarationAnnexPDF.tsx` y `LoanAgreementAnnexPDF.tsx` tenían el logo apuntando a una URL remota de S3 (`andes-public-data.s3.amazonaws.com/andes-logo.png`) que no funciona con `@react-pdf/renderer` en el browser.
- Corregidos para usar `/images/logo-andes.png` (ruta local), igual que todos los demás templates.
- Alineación del header corregida a `center` (era `flex-end`).

**Actualización de copy** (`JobSeekerLandingPage.tsx`):
- Textos actualizados en sección de steps, benefits, stats y hero subtitle.

### ¿Por qué se implementó?

Los contratistas deben firmar una autorización de uso de imagen. El flujo existente de ESIGN/anexos ya soporta este tipo de documento, solo faltaba el template PDF y la entrada en el modal.

### Decisiones de diseño

- Se mantuvo exactamente el mismo flujo de subida y firma que los anexos existentes (PDF → S3 → ESIGN → firma del contratista), sin cambios en la API.
- El logo se referencia por ruta local `/images/logo-andes.png` porque `@react-pdf/renderer` no puede hacer fetch de URLs externas en el contexto del browser.

## Archivos principales modificados

| Archivo | Cambio |
|---|---|
| `src/.../templates/ImageUseAuthorizationAnnexPDF.tsx` | ✅ Nuevo — template PDF del anexo |
| `src/.../contracts/components/SendAnnexModal.tsx` | Import, entrada en templates array, casos preview y send |
| `src/.../templates/ComplianceDeclarationAnnexPDF.tsx` | Fix logo src + alineación header |
| `src/.../templates/LoanAgreementAnnexPDF.tsx` | Fix logo src + alineación header |
| `src/.../offers/components/JobSeekerLandingPage.tsx` | Actualización de copy (RM-91) |

## Cómo probar / QA

1. Pre-condiciones: tener un proceso de contratación activo con un candidato que tenga `nombreCompleto` y `cedula`.
2. Pasos:
   1. Ir a Admin → Contratos → abrir proceso de contratación.
   2. Abrir modal "Send Annex".
   3. Seleccionar **"ANNEX – IMAGE USE AUTHORIZATION"**.
   4. Verificar preview del PDF: logo visible, nombre y cédula en negrita, texto completo correcto.
   5. Enviar el anexo.
   6. Verificar que el contratista recibe el email con el link de firma.
   7. Firmar y verificar que el documento queda en la lista de anexos.
3. Resultado esperado: flujo idéntico al de los demás anexos (Compliance Declaration, Loan Agreement, etc.).

## Checklist

- [x] Los commits siguen la [guía de commits](../../commit-guide/COMMIT_GUIDE.md) del equipo.
- [x] Sin imports ni código no utilizado.
- [x] Build y linter pasan localmente.
- [x] Zero errores TypeScript en los archivos modificados.
- [ ] Tests añadidos o actualizados cuando corresponda.

## Notas para el reviewer

- El fix del logo en `ComplianceDeclarationAnnexPDF` y `LoanAgreementAnnexPDF` corrige un bug silencioso preexistente — el logo no aparecía en esos PDFs. Está incluido en este PR por ser parte del mismo contexto.
- No hay cambios en la API para este PR.

## Capturas

_PDF preview del nuevo template con logo, título centrado, nombre en negrita y lista de bullet points._
