-- Consulta para obtener el ID de video de los contratistas de prioridad alta
-- Basado en el Application Reinstatement Audit - Andes Workforce.xlsx
-- Hoja: Prioridad Alta
-- Fecha: 17 agosto 2026

SELECT 
    id,
    "nombreCompleto",
    correo,
    "videoPresentacion",
    CASE 
        WHEN "videoPresentacion" IS NOT NULL THEN '✓ Tiene video'
        ELSE '✗ Sin video'
    END AS estado_video
FROM "Usuario"
WHERE correo IN (
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
    "nombreCompleto";

-- RESUMEN: Contratistas con y sin video
SELECT 
    CASE 
        WHEN "videoPresentacion" IS NOT NULL THEN 'CON video'
        ELSE 'SIN video'
    END AS categoria,
    COUNT(*) AS cantidad
FROM "Usuario"
WHERE correo IN (
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

-- LISTAR SOLO LOS QUE TIENEN VIDEO (para subir al bucket)
SELECT 
    id,
    "nombreCompleto",
    correo,
    "videoPresentacion"
FROM "Usuario"
WHERE correo IN (
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
AND "videoPresentacion" IS NOT NULL
ORDER BY "nombreCompleto";
