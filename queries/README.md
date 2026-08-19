# Consultas SQL de Andes Workforce

## Conectarse a la base de datos

Seguí las instrucciones en:

```
ANDES-DOCS/scripts/CONECTAR_PGADMIN_PRODUCCION.md
```

## Consultas disponibles

### `buscar_videos_contratistas_prioridad_alta.sql`

**Propósito:** Obtener el ID de video (`videoPresentacion`) de los 21 contratistas listados en el Excel "Application Reinstatement Audit - Andes Workforce.xlsx" (hoja: Prioridad Alta).

**Fecha:** 17 agosto 2026

**Salida esperada:**
- Lista completa con columna `estado_video` (✓ Tiene video / ✗ Sin video)
- Resumen: cantidad con video vs sin video
- Lista filtrada: solo los que tienen video (para descargar de S3)

**Cómo ejecutar:**

1. Abrí pgAdmin4 y conectate a `andes_prod` (ver instrucciones arriba)
2. Clic derecho en `andes_prod` → **Query Tool**
3. Abrí el archivo `buscar_videos_contratistas_prioridad_alta.sql`
4. Ejecutá con **F5** o botón ▶
5. Revisá los 3 resultados (cada query genera un resultado separado)

**Columnas importantes:**

- `id`: UUID del usuario (PK)
- `nombreCompleto`: Nombre completo del contratista
- `correo`: Email (usado para buscar en la tabla)
- `videoPresentacion`: URL completa del video en S3, ej:
  ```
  https://andes-workforce-s3.s3.us-east-2.amazonaws.com/videos/uuid-nombre-timestamp.mp4
  ```

**Nota sobre S3:**

Según el informe del incidente, el bucket `andes-workforce-s3` fue eliminado el 11 agosto 2026. Las URLs en la columna `videoPresentacion` apuntan al bucket viejo. Para restaurar:

1. Recuperar los archivos de la copia en `c:\Users\DavidMorcillo\OneDrive - Andes Workforce\Documentos\andes-data\andes-workforce-s3\videos\`
2. Subir a un **bucket nuevo privado** (ver `RECONEXION_S3_POST_INCIDENTE.md`)
3. Actualizar las URLs en la base de datos (consulta de `UPDATE` pendiente)

---

### `buscar_contratos_contratistas_prioridad_alta.sql`

**Propósito:** Obtener los códigos/URLs de los PDFs de contratos de los 21 contratistas listados en el Excel "Application Reinstatement Audit - Andes Workforce.xlsx" (hoja: Prioridad Alta).

**Fecha:** 18 agosto 2026

**Salida esperada:**
- Lista completa con información de contratos y URLs
- Resumen: cantidad con contrato vs sin contrato
- Lista filtrada: solo los que tienen contratos (para descargar de S3)
- Análisis de estados de contratación

**Cómo ejecutar:**

1. Abrí pgAdmin4 y conectate a `andes_prod` (ver instrucciones arriba)
2. Clic derecho en `andes_prod` → **Query Tool**
3. Abrí el archivo `buscar_contratos_contratistas_prioridad_alta.sql`
4. Ejecutá con **F5** o botón ▶
5. Revisá los 4 resultados (cada query genera un resultado separado)

**Columnas importantes:**

- `usuario_id`: UUID del usuario
- `nombreCompleto`: Nombre completo del contratista
- `correo`: Email
- `proceso_contratacion_id`: UUID del proceso de contratación
- `puestoTrabajo`: Posición/puesto
- `estadoContratacion`: Estado del proceso (FIRMADO_COMPLETO, etc.)
- `contratoFinalUrl`: URL del contrato final en S3
- `signWellDownloadUrl`: URL de descarga desde SignWell
- `documentoFirmado`: URL del documento firmado
- `codigo_pdf_contrato_final`: Solo el nombre del archivo PDF extraído de la URL

**Tablas involucradas:**

- `Usuario`: Datos del contratista
- `Postulacion`: Postulaciones del candidato
- `ProcesoContratacion`: Proceso de contratación y URLs de contratos

**Nota sobre múltiples contratos:**

Un contratista puede tener múltiples procesos de contratación (diferentes posiciones/contratos). La consulta los muestra todos ordenados por fecha más reciente primero.

**Nota sobre S3:**

Al igual que con los videos, el bucket `andes-workforce-s3` fue eliminado. Las URLs en las columnas de contratos apuntan al bucket viejo. Para restaurar:

1. Recuperar los archivos de la copia en `c:\Users\DavidMorcillo\OneDrive - Andes Workforce\Documentos\andes-data\andes-workforce-s3\contratos\`
2. Subir a un **bucket nuevo privado**
3. Actualizar las URLs en la base de datos

---

## Plantilla para nuevas consultas

Al agregar una nueva consulta, incluí un comentario al inicio con:

```sql
-- Nombre: [Título descriptivo]
-- Propósito: [Qué resuelve]
-- Fecha: [YYYY-MM-DD]
-- Autor: [Tu nombre]
-- Tablas: [Lista de tablas involucradas]
```

Y documentala en este README.
