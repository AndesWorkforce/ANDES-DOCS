-- Consulta para obtener los códigos/URLs de contratos PDF de los contratistas de prioridad alta
-- Basado en el Application Reinstatement Audit - Andes Workforce.xlsx
-- Hoja: Prioridad Alta
-- Fecha: 18 agosto 2026

-- =====================================================
-- CONSULTA PRINCIPAL: Contratos de contratistas
-- =====================================================

SELECT 
    u.id AS usuario_id,
    u."nombreCompleto",
    u.correo,
    p.id AS postulacion_id,
    pc.id AS proceso_contratacion_id,
    pc."nombreCompleto" AS nombre_en_contrato,
    pc."puestoTrabajo",
    pc."estadoContratacion",
    pc."contratoFinalUrl",
    pc."signWellDownloadUrl",
    pc."documentoFirmado",
    pc."fechaFirma",
    pc."fechaFirmaCandidato",
    pc."fechaFirmaProveedor",
    pc.activo AS contrato_activo,
    CASE 
        WHEN pc."contratoFinalUrl" IS NOT NULL THEN '✓ Contrato Final'
        WHEN pc."signWellDownloadUrl" IS NOT NULL THEN '✓ SignWell'
        WHEN pc."documentoFirmado" IS NOT NULL THEN '✓ Documento Firmado'
        ELSE '✗ Sin contrato'
    END AS estado_contrato
FROM "Usuario" u
LEFT JOIN "Postulacion" p ON p."candidatoId" = u.id
LEFT JOIN "ProcesoContratacion" pc ON pc."postulacionId" = p.id
WHERE u.correo IN (
    'juliarlina@gmail.com',
    'herrienopradez@gmail.com',
    'francolissidaniela@gmail.com',
    'mgabrielacastillo35@gmail.com',
    'rodrigo.serrano.vargas@hotmail.com',
    'judimux1996@gmail.com',
    'juanramirez81@hotmail.com',
    'ana.i.mendiola95@gmail.com',
    'frankalexivio8@gmail.com',
    'giron98ur@gmail.com',
    'lauchalarce4@gmail.com',
    'camidiettes@gmail.com',
    'dsoulan34@gmail.com',
    'andreamejiarodriguez@hotmail.com',
    'angitucueta0@gmail.com',
    'Camilo.Andres.17@gmail.com',
    'd.oliviera37@icloud.com',
    'obedevalle1@gmail.com',
    'E.samuel.padilla27@gmail.com',
    'mazluengas@gmail.com',
    'josiesgonzalez95@gmail.com'
)
ORDER BY 
    u."nombreCompleto",
    pc."fechaInicio" DESC;


-- =====================================================
-- RESUMEN: Contratistas con y sin contratos
-- =====================================================

SELECT 
    CASE 
        WHEN pc.id IS NOT NULL THEN 'CON contrato'
        ELSE 'SIN contrato'
    END AS categoria,
    COUNT(DISTINCT u.id) AS cantidad_contratistas
FROM "Usuario" u
LEFT JOIN "Postulacion" p ON p."candidatoId" = u.id
LEFT JOIN "ProcesoContratacion" pc ON pc."postulacionId" = p.id
WHERE u.correo IN (
    'juliarlina@gmail.com',
    'herrienopradez@gmail.com',
    'francolissidaniela@gmail.com',
    'mgabrielacastillo35@gmail.com',
    'rodrigo.serrano.vargas@hotmail.com',
    'judimux1996@gmail.com',
    'juanramirez81@hotmail.com',
    'ana.i.mendiola95@gmail.com',
    'frankalexivio8@gmail.com',
    'giron98ur@gmail.com',
    'lauchalarce4@gmail.com',
    'camidiettes@gmail.com',
    'dsoulan34@gmail.com',
    'andreamejiarodriguez@hotmail.com',
    'angitucueta0@gmail.com',
    'Camilo.Andres.17@gmail.com',
    'd.oliviera37@icloud.com',
    'obedevalle1@gmail.com',
    'E.samuel.padilla27@gmail.com',
    'mazluengas@gmail.com',
    'josiesgonzalez95@gmail.com'
)
GROUP BY categoria;


-- =====================================================
-- SOLO CONTRATISTAS CON CONTRATOS (para descargar)
-- =====================================================

SELECT 
    u.id AS usuario_id,
    u."nombreCompleto",
    u.correo,
    pc.id AS proceso_contratacion_id,
    pc."puestoTrabajo",
    pc."estadoContratacion",
    pc."contratoFinalUrl" AS url_principal,
    pc."signWellDownloadUrl" AS url_signwell,
    pc."documentoFirmado" AS url_documento_firmado,
    -- Extraer solo el nombre del archivo (código del PDF)
    SUBSTRING(
        pc."contratoFinalUrl" FROM 
        'contratos/([^/]+\.pdf)'
    ) AS codigo_pdf_contrato_final,
    SUBSTRING(
        pc."documentoFirmado" FROM 
        'contratos/([^/]+\.pdf)'
    ) AS codigo_pdf_documento_firmado
FROM "Usuario" u
INNER JOIN "Postulacion" p ON p."candidatoId" = u.id
INNER JOIN "ProcesoContratacion" pc ON pc."postulacionId" = p.id
WHERE u.correo IN (
    'juliarlina@gmail.com',
    'herrienopradez@gmail.com',
    'francolissidaniela@gmail.com',
    'mgabrielacastillo35@gmail.com',
    'rodrigo.serrano.vargas@hotmail.com',
    'judimux1996@gmail.com',
    'juanramirez81@hotmail.com',
    'ana.i.mendiola95@gmail.com',
    'frankalexivio8@gmail.com',
    'giron98ur@gmail.com',
    'lauchalarce4@gmail.com',
    'camidiettes@gmail.com',
    'dsoulan34@gmail.com',
    'andreamejiarodriguez@hotmail.com',
    'angitucueta0@gmail.com',
    'Camilo.Andres.17@gmail.com',
    'd.oliviera37@icloud.com',
    'obedevalle1@gmail.com',
    'E.samuel.padilla27@gmail.com',
    'mazluengas@gmail.com',
    'josiesgonzalez95@gmail.com'
)
AND pc.activo = true
AND (
    pc."contratoFinalUrl" IS NOT NULL 
    OR pc."signWellDownloadUrl" IS NOT NULL
    OR pc."documentoFirmado" IS NOT NULL
)
ORDER BY 
    u."nombreCompleto",
    pc."fechaInicio" DESC;


-- =====================================================
-- ANÁLISIS DE ESTADOS DE CONTRATACIÓN
-- =====================================================

SELECT 
    pc."estadoContratacion",
    COUNT(*) AS cantidad,
    STRING_AGG(u."nombreCompleto", ', ') AS contratistas
FROM "Usuario" u
INNER JOIN "Postulacion" p ON p."candidatoId" = u.id
INNER JOIN "ProcesoContratacion" pc ON pc."postulacionId" = p.id
WHERE u.correo IN (
    'juliarlina@gmail.com',
    'herrienopradez@gmail.com',
    'francolissidaniela@gmail.com',
    'mgabrielacastillo35@gmail.com',
    'rodrigo.serrano.vargas@hotmail.com',
    'judimux1996@gmail.com',
    'juanramirez81@hotmail.com',
    'ana.i.mendiola95@gmail.com',
    'frankalexivio8@gmail.com',
    'giron98ur@gmail.com',
    'lauchalarce4@gmail.com',
    'camidiettes@gmail.com',
    'dsoulan34@gmail.com',
    'andreamejiarodriguez@hotmail.com',
    'angitucueta0@gmail.com',
    'Camilo.Andres.17@gmail.com',
    'd.oliviera37@icloud.com',
    'obedevalle1@gmail.com',
    'E.samuel.padilla27@gmail.com',
    'mazluengas@gmail.com',
    'josiesgonzalez95@gmail.com'
)
AND pc.activo = true
GROUP BY pc."estadoContratacion"
ORDER BY cantidad DESC;


-- =====================================================
-- NOTAS IMPORTANTES:
-- =====================================================
-- 
-- 1. contratoFinalUrl: URL principal del contrato final
-- 2. signWellDownloadUrl: URL de descarga desde SignWell (firma electrónica externa)
-- 3. documentoFirmado: URL del documento firmado
-- 
-- 4. Un contratista puede tener múltiples procesos de contratación (diferentes posiciones)
--    Por eso se ordena por fechaInicio DESC para ver el más reciente primero
-- 
-- 5. Estados de contratación posibles:
--    - PENDIENTE_DOCUMENTOS
--    - DOCUMENTOS_EN_LECTURA
--    - DOCUMENTOS_COMPLETADOS
--    - PENDIENTE_FIRMA_CANDIDATO
--    - FIRMADO_CANDIDATO
--    - LECTURA_DOCS_COMPLETA
--    - PENDIENTE_FIRMA_PROVEEDOR
--    - FIRMADO_COMPLETO
--    - CONTRATO_FINALIZADO
--    - CANCELADO
--    - EXPIRADO
-- 
-- 6. Para extraer los códigos de los PDFs del bucket S3, usar la tercera consulta
--    que extrae solo el nombre del archivo de la URL completa
