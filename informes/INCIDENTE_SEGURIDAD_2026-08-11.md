# Incidente de Seguridad — Andes Workforce

**Clasificación:** Confidencial — distribución restringida
**Fecha del informe:** 11 de agosto de 2026
**Elaborado por:** David Morcillo
**Estado:** Investigación en curso

> **Nota sobre este documento.** Los valores de las credenciales comprometidas han sido
> redactados intencionalmente. Los valores completos están en el servidor de producción y
> no deben circular por correo, chat ni documentos compartidos. Este documento sí es apto
> para compartir con dirección, asesoría legal y un equipo de respuesta a incidentes.

---

## 1. Resumen ejecutivo

El 11 de agosto de 2026 se recibió un correo de extorsión dirigido al Sr. Rendón, firmado
por un grupo autodenominado "ETHICS TEAM", en el que se afirma haber exfiltrado la
totalidad de los datos de producción de Andes Workforce y haber destruido los tres buckets
de almacenamiento en AWS S3. El correo otorga un plazo de 72 horas para establecer
contacto a través de un enlace en la red TOR.

La investigación técnica confirmó el vector de compromiso: **las credenciales de acceso a
AWS estaban almacenadas en texto plano en los archivos de configuración del servidor de
producción y en las variables de entorno de los contenedores Docker.** No se trató de una
vulnerabilidad de AWS ni de un ataque sofisticado a la infraestructura.

**Hasta el momento no existe evidencia de que el servidor de producción haya sido
comprometido.** Todos los indicadores apuntan a que el atacante operó desde el exterior
usando las credenciales filtradas. Está pendiente la confirmación mediante un triage
forense del host.

### Gravedad

El conjunto de datos expuesto incluye datos bancarios completos, documentos de identidad,
fecha de nacimiento y domicilio de las personas registradas en la plataforma, así como
contratos firmados, imágenes de firmas manuscritas y — de forma adicional — un grupo de
contraseñas almacenadas sin cifrar. La combinación de estos elementos constituye material
directamente utilizable para fraude financiero y suplantación de identidad.

Adicionalmente se expuso información comercialmente sensible: el salario de cada
contratista junto con el precio facturado al cliente final, lo que revela el margen de
Andes por persona.

---

## 2. Cronología

| Fecha / hora (UTC-5) | Evento |
|---|---|
| 2026-08-06 | Último despliegue de los contenedores `api_prod` y `client_prod` |
| 2026-08-09 14:00 | Intentos de acceso SSH fallidos desde `147.139.194.234` |
| 2026-08-10 02:36–02:38 | Intentos SSH fallidos desde `34.14.120.226` y `34.76.149.154` (Google Cloud) |
| 2026-08-10 03:56 | Intentos SSH fallidos desde `116.110.20.122` |
| 2026-08-10 04:42 | `171.231.184.214` baneada por fail2ban |
| 2026-08-10 04:46 | `171.231.185.251` baneada por fail2ban |
| 2026-08-10 23:03 | Intento SSH fallido desde `159.203.182.122` |
| 2026-08-11 06:25 | Reinicio del servicio fail2ban |
| 2026-08-11 15:41 | `146.190.131.65` y `165.227.227.17` baneadas (Digital Ocean, NYC) |
| 2026-08-11 15:59–16:03 | Segundo baneo de las mismas dos IPs tras reintento |
| 2026-08-11 (mañana) | Se detecta imposibilidad de acceder a los buckets de S3 y fallo de carga de imágenes en la plataforma |
| 2026-08-11 | Recepción del correo de extorsión |
| 2026-08-11 17:00–18:00 | Investigación técnica: identificación del vector de compromiso |

**Observación importante sobre los intentos SSH.** Los intentos registrados por fail2ban
corresponden a escaneo automatizado de fuerza bruta, actividad de fondo permanente en
cualquier servidor expuesto a internet. **No hay correlación establecida entre estos
intentos y el compromiso de AWS.** Ninguno resultó en un acceso exitoso. El compromiso se
produjo por una vía distinta.

**Fecha exacta del acceso a AWS: pendiente de determinar.** Requiere consulta a AWS
CloudTrail. Es el dato más importante que falta.

---

## 3. Vector de compromiso

### 3.1 Origen de la filtración

Las credenciales de AWS (`AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`) se encontraron en
texto plano en cuatro ubicaciones del servidor de producción:

```
/home/sysadmin/app/.env
/home/sysadmin/app/api/.env
/home/sysadmin/app/client/.env          (otras credenciales)
Variables de entorno del contenedor api_prod
Variables de entorno del contenedor db_prod   (innecesarias en este contenedor)
```

Verificado mediante:

```bash
cat /proc/<pid>/environ | tr '\0' '\n' | grep -i aws
docker inspect <container> --format='{{json .Config.Env}}'
```

### 3.2 Alcance de la credencial de AWS

El código de la aplicación (`src/files/files.service.ts`, `src/s3-cleanup/s3-cleanup.service.ts`)
invoca las siguientes operaciones con esa credencial:

- `listBuckets()` — **enumera todos los buckets de la cuenta**, no solo el propio
- `putObject`, `getObject`, `deleteObject`, `listObjectsV2`
- `getSignedUrlPromise` (generación de URLs firmadas)

La capacidad de `listBuckets` es consistente con la afirmación del atacante de haber
destruido tres buckets distintos. **Pendiente: verificar en la consola IAM si la
credencial tenía permisos fuera de S3.**

### 3.3 Segundo vector: exposición pública de S3

Independientemente de la filtración de credenciales, el análisis del código indica que el
bucket estaba configurado con lectura pública:

En `src/files/files.service.ts`, la operación `putObject` no establece ACL, pero el método
que devuelve la ubicación del archivo construye una URL directa sin firmar:

```typescript
getPublicUrl(key: string): string {
  return `https://${this.bucketName}.s3.${this.region}.amazonaws.com/${key}`;
}
```

Y el método `getFileBuffer()` intenta primero una descarga HTTP plana (`fetch(url)`) antes
de recurrir al SDK autenticado. Para que ese flujo funcionara, el bucket debía tener
política de lectura pública.

**Implicación:** las fotos de cédula, hojas de vida y contratos firmados fueron accesibles
por URL directa, sin autenticación, para cualquiera que conociera o adivinara la ruta —
posiblemente durante todo el tiempo de operación de la plataforma y con anterioridad a la
filtración de credenciales. Esta es probablemente la vía por la que el atacante descubrió
el objetivo.

**Pendiente de confirmar:** la política del bucket no puede verificarse porque el bucket
fue eliminado. CloudTrail o una configuración replicada permitirían confirmarlo.

---

## 4. Datos personales afectados

Todo lo siguiente reside en la base de datos PostgreSQL `andes_prod`, que según el correo
de extorsión fue copiada íntegramente. Referencias al modelo `Usuario` de
`prisma/schema.prisma` (60 modelos, 56 KB).

### 4.1 Identidad y documentos

| Campo | Descripción |
|---|---|
| `nombre`, `apellido`, `nombreCompleto`, `alias` | Nombre completo |
| `documento`, `documentoIdentidad` | Número de documento de identidad |
| `fechaNacimiento` | Fecha de nacimiento |
| `pais`, `paisCodigo` | Nacionalidad / país |
| `profesion`, `nivelEstudios`, `nivelIngles` | Perfil profesional |

### 4.2 Domicilio y contacto

`direccionResidencia`, `ciudadResidencia`, `estadoResidencia`, `residencia`, `telefono`,
`correo`, `correoEmpresa`

### 4.3 Datos bancarios — categoría de mayor gravedad

| Campo | Descripción |
|---|---|
| `numeroCuentaBancaria` | Número de cuenta bancaria |
| `numeroRutaBancaria` | Número de ruta / routing number |
| `nombreTitularCuenta` | Titular de la cuenta |
| `bancoNombre`, `bancoPais`, `direccionBanco` | Entidad bancaria |
| `dollarTag`, `usaDollarApp` | Identificador de pago alterno |

La combinación de número de cuenta, número de ruta, titular, domicilio, documento de
identidad y fecha de nacimiento permite fraude financiero directo y apertura de productos
financieros a nombre de las personas afectadas.

### 4.4 Credenciales de acceso

| Campo | Descripción |
|---|---|
| `contrasena` | Contraseña — mayoritariamente bcrypt, **parcialmente en texto plano** |
| `passwordResetToken`, `passwordResetExpires` | Tokens de restablecimiento |

**Hallazgo crítico.** En `src/auth/auth.service.ts` (líneas 274–289) existe un mecanismo de
compatibilidad heredado de la migración desde Power Apps:

```typescript
// Fallback de compatibilidad: si el hash en BD no parece bcrypt, probar igualdad directa
const looksLikeBcrypt = typeof stored === 'string' && stored.startsWith('$2');
if (!looksLikeBcrypt && contrasenaLimpia && stored) {
  if (contrasenaLimpia === stored) {
    contrasenaValida = true;
    // ... migra a bcrypt tras el primer login exitoso
  }
}
```

Esto implica que las contraseñas de usuarios migrados **que aún no han iniciado sesión
desde la migración están almacenadas en texto plano**. Esas cuentas quedan comprometidas de
forma inmediata, sin necesidad de descifrar nada. Dado que la reutilización de contraseñas
es habitual, el impacto se extiende a las cuentas personales de correo y banca de esas
personas — lo que eleva el carácter urgente de la notificación a los afectados.

Cuantificación pendiente (ver sección 8).

### 4.5 Compensación, nómina y facturación

Campos en `ProcesoContratacion`: `ofertaSalarial`, `monedaSalario`, `clientPrice`,
`discretionaryBonusType`, `paidHolidays`, `tipoJornada`, `fechaInicioLabores`,
`fechaPermanente`, `paisFacturacion`.

Modelos completos afectados: `Nomina`, `LineaNomina`, `NominaSnapshot`, `Deduccion`,
`VariableIngreso`, `IncomeVariable`, `RegistroHorasExtra`, `RegistroFestivoLaborado`,
`IPBRequest`, `IpbMensualSnapshot`, `DiaLibre`, `PaymentInbox`, `CustomerCredit`,
`CustomerCharge`, `FacturaClienteSnapshot`, `ClientInvoiceSnapshot`,
`EvaluacionPagoMensual`.

**Doble impacto:** expone el salario individual de cada contratista, y simultáneamente el
margen de Andes por persona (diferencia entre `clientPrice` y `ofertaSalarial`). Lo
segundo es secreto comercial frente a clientes y competencia.

### 4.6 Evaluaciones internas — riesgo reputacional

| Origen | Contenido |
|---|---|
| `Postulacion.notasInternas` | Notas internas sobre candidatos |
| `Usuario.clasificacionGlobal`, `notasClasificacionGlobal` | Clasificación interna de personas |
| `Usuario.favorite`, `isFeatured` | Marcadores de preferencia |
| `BitacoraPostulante` | Bitácora de eventos por candidato |
| `ClasificacionEmpresa` | Clasificación de candidatos por empresa cliente |
| `EvaluacionPagoMensual.observacionesRevision` | Observaciones de evaluación de pago |

Son valoraciones redactadas bajo el supuesto de confidencialidad interna. Su divulgación
genera un daño de naturaleza distinta al de un dato bancario, y en la relación con las
personas afectadas puede ser más severo.

### 4.7 Firma electrónica — riesgo de falsificación documental

En `SignatureRecipient`: `nombre`, `email`, `telefono`, `estado`, `signToken`,
`documentoFirmadoUrl` y **`signatureImageUrl`** — la imagen de la firma manuscrita de cada
firmante.

En `SignatureAudit`: `ip`, `userAgent`, `metadata` de cada acción de firma.

La combinación de imágenes de firma manuscrita con los PDFs de contratos permite fabricar
documentos firmados de apariencia legítima.

**Riesgo activo adicional:** los valores de `signToken` exfiltrados siguen siendo válidos.
Ver sección 7.3.

### 4.8 Datos de clientes corporativos

`Empresa.contactoEmail`, `contactoNombre`, `contactoTelefono`, `division`, `estado`,
`paisCodigo`. Modelo `Propuesta` con `titulo`, `descripcion`, `requerimientos`,
`seniority`, `cantidadPosiciones`, `deadline`.

### 4.9 Registros operativos

`EmailLog` (destinatarios, asuntos, metadata de correos enviados),
`ContractWebhookLog`, `HistorialEnvioProveedor`, `Notificacion`, `FeatureFlag`,
`S3CleanupBackup` (inventarios históricos de archivos en S3).

---

## 5. Inventario de S3

### 5.1 Bucket `andes-workforce-s3` — región `us-east-2`

**Documentos de identidad**
- Fotos de cédula, cara frontal (`Usuario.fotoCedulaFrente`)
- Fotos de cédula, cara posterior (`Usuario.fotoCedulaDorso`)

**Documentos laborales y contractuales**
- Contratos firmados finales — `esign/documents/{documentId}/final.pdf`
- Documentos firmados por candidato y proveedor (`documentoFirmado`, `contratoFinalUrl`)
- Documentos origen, generados y firmados de e-sign (`archivoOrigenUrl`, `archivoGeneradoUrl`, `archivoFirmadoUrl`)
- Imágenes de firmas manuscritas (`signatureImageUrl`)
- Anexos de contrato
- Documentos de soporte de pago mensual (`EvaluacionPagoMensual.documentoSubido`)

**Documentos de postulación** — prefijos `uploads/cvs`, `uploads/applications`
- Hojas de vida / CVs (`Usuario.curriculum`, `Postulacion.cv`)
- Documentos adicionales cargados por el candidato (`documentosAdicionales[]`, `documentosPostulacion[]`)

**Multimedia personal** — prefijos `uploads/profiles`, `uploads/videos`, `videos/`
- Fotos de perfil (`fotoPerfil`)
- Videos de presentación personal (`videoPresentacion`)

**Capturas de verificación técnica** — prefijo `uploads/tests`
- Test de velocidad de internet (`imagenTestVelocidad`)
- Requerimientos de equipo (`imagenRequerimientosPC`)
- Pruebas externas / assessments (`imagenTestExterno`)
- Verificación de país (`paisImagen`)

**Otros prefijos en uso:** `images/`, `documents/`, `documents/esign`, `prescriptions/`

### 5.2 Buckets reportados como destruidos

| Bucket | Detalle según el correo de extorsión |
|---|---|
| `andes-workforce-s3` | 14.252 objetos / 83,8 GB — 14.562 versiones de objeto purgadas |
| `andes-backups-private` | 8 backups |
| `dev-test-andesworkforce` | — |

El atacante afirma que el versionado fue suspendido, las versiones de objeto purgadas y
que no existían backups de S3 independientes.

**Estas afirmaciones no han sido verificadas de forma independiente.** Deben confirmarse
en CloudTrail y en la consola de S3 desde un usuario con permisos suficientes antes de
darse por ciertas. Los actores de extorsión habitualmente exageran el alcance de la
destrucción para presionar.

### 5.3 Reconstrucción del inventario de archivos perdidos

Aunque los buckets estén eliminados, **la base de datos conserva la ruta de cada objeto**
en las columnas de tipo URL. Esto permite reconstruir el inventario exacto de lo perdido,
necesario tanto para dimensionar la recuperación como para la notificación a los
afectados. Consulta en sección 8.3.

---

## 6. Infraestructura del servidor de producción

### 6.1 Host

| Parámetro | Valor |
|---|---|
| Hostname | `srv785336` |
| Sistema operativo | Ubuntu |
| Orquestación | Docker + Docker Compose |
| Usuario del sistema | `sysadmin` |
| Ruta de la aplicación | `/home/sysadmin/app` (interior del contenedor: `/app`) |
| Dominios | `andes-workforce.com`, `andesworkforce.com`, `andes.api.andes-workforce.com` |
| Proxy inverso | Traefik v3.6.1 — puertos 80, 443, 8082 |
| Firewall | UFW + nftables |
| Protección de fuerza bruta | fail2ban v1.0.2 |

### 6.2 Contenedores en ejecución

| Contenedor | Imagen | Puerto interno | Antigüedad |
|---|---|---|---|
| `api_prod` | app-api (NestJS, Node 20.20.2) | 3000 | 5 días |
| `client_prod` | app-client (Next.js) | 3000 | 5 días |
| `db_prod` | postgres:15-alpine | 5432 | 2 meses |
| `redis_prod` | redis:7-alpine | 6379 | 2 meses |
| `adminer_prod` | adminer | 8080 | 2 meses |
| `traefik` | traefik:v3.6.1 | 80, 443, 8082 | 8 semanas |
| `prometheus` | prom/prometheus:v2.51.2 | 9090 | 5 semanas |
| `grafana` | grafana/grafana:10.4.2 | 3000 | 8 semanas |
| `node_exporter` | prom/node-exporter:v1.8.0 | 9100 | 8 semanas |
| `docker_stats_exporter` | docker-stats-exporter | 9200 | 8 semanas |

Únicamente Traefik publica puertos al host. El resto de servicios es accesible solo a
través de la red interna de Docker o mediante las rutas que Traefik exponga.

### 6.3 Bases de datos

| Motor | Base | Usuario | Notas |
|---|---|---|---|
| PostgreSQL 15 | `andes_prod` | `andesworkforce` | 60 tablas; `connection_limit=20` |
| Redis 7 | DB 5 | — | Colas BullMQ para procesos asíncronos |

### 6.4 Configuración de fail2ban — insuficiente

| Parámetro | Valor actual | Observación |
|---|---|---|
| Jails activos | 1 (`sshd` únicamente) | Sin cobertura de la capa web, que es el vector real |
| `maxRetry` | 5 | — |
| `findtime` | 600 s | — |
| `banTime` | 600 s | Un atacante reintenta indefinidamente cada 10 minutos |
| Jail `recidive` | No existe | Sin escalado de sanción para reincidentes |
| Total baneos históricos | 4 | — |

Las IPs `146.190.131.65` y `165.227.227.17` fueron baneadas y liberadas dos veces el mismo
día, reanudando el ataque en cada ciclo.

---

## 7. Credenciales y servicios comprometidos

Todas las credenciales siguientes estaban en texto plano en los archivos y variables de
entorno indicados en la sección 3.1. **Todas deben considerarse comprometidas,
independientemente de que se confirme su uso por parte del atacante.**

### 7.1 Inventario

| # | Servicio | Credencial | Impacto | Prioridad |
|---|---|---|---|---|
| 1 | AWS IAM | `AKIAYTMVPPU4DW4Y3LGB` + secret | Enumeración de todos los buckets de la cuenta; lectura, escritura y borrado de objetos. Verificar permisos fuera de S3. | Inmediata |
| 2 | Aplicación | `JWT_SECRET` | Permite **firmar tokens de sesión válidos para cualquier usuario y cualquier rol, incluido ADMIN**, sin tocar la base de datos. Sin rotarlo, el resto de medidas es inefectivo. | Inmediata |
| 3 | Aplicación | `SECRET_KEY_ADMIN_CREATOR` | Permite crear usuarios administradores vía `POST /api/usuarios/admin`. Ver 7.2. | Inmediata |
| 4 | PostgreSQL | usuario `andesworkforce` + contraseña | Acceso total a los datos de la sección 4. | Inmediata |
| 5 | Microsoft 365 | `rromero@teamandes.com` + contraseña | Cuenta de correo corporativa real. Sin MFA implica toma de control del buzón y base para fraude de facturación (BEC). | Inmediata |
| 6 | Office 365 / Graph | Client ID + Client Secret + Tenant ID | Credencial de aplicación. Alcance según permisos concedidos; si incluye `Mail.Send` o `Mail.ReadWrite` a nivel de aplicación, afecta al correo de toda la organización. | Inmediata |
| 7 | Resend | API Key | Envío de correo firmado desde los dominios de Andes → phishing creíble hacia contratistas y clientes. | Alta |
| 8 | Cloudflare R2 | Token + endpoints (predeterminado y UE) | Almacenamiento alterno (`r2-appwise`). Verificar contenido y validez. | Alta |
| 9 | Redis | contraseña | Colas y caché. No publicado al host. | Media |
| 10 | SMTP | `rromero@teamandes.com` (misma que #5) | Envío de correo saliente. | Inmediata |

### 7.2 Cadena de escalado a administrador

El endpoint de creación de administradores está protegido únicamente por una clave
estática en un header:

`src/usuarios/usuarios.controller.ts` línea 63:

```typescript
@Post('admin')
@UseGuards(AdminCreatorGuard)
@ApiHeader({
  name: 'x-admin-creator-key',
  description: 'Clave secreta para creación de administradores',
  required: true,
})
createAdmin(@Body() createUsuarioDto: CreateUsuarioDto) { ... }
```

`src/common/guards/admin-creator.guard.ts` compara el header con
`SECRET_KEY_ADMIN_CREATOR`, sin control de origen, sin rate limiting específico y sin
registro de auditoría.

Dado que la documentación Swagger está publicada en producción (ver 7.4), el nombre exacto
del header y la firma del endpoint eran de conocimiento público. Con la clave filtrada, la
creación de una cuenta administradora es una sola petición HTTP.

**Acción requerida:** auditar la tabla de usuarios en busca de cuentas administradoras no
reconocidas (consulta en 8.2).

### 7.3 Tokens de firma electrónica activos

`src/esign/esign.controller.ts` expone dos endpoints sin autenticación:

- `GET /api/esign/public/sign/:token` (línea 1717) — devuelve el documento a firmar
- `POST /api/esign/public/sign/:token` (línea 1848) — ejecuta la firma

La autorización depende exclusivamente del valor de `signToken`, almacenado en la tabla
`SignatureRecipient` — exfiltrada. **El atacante puede abrir y firmar cualquier documento
pendiente suplantando al firmante legítimo.** Todos los tokens no consumidos deben
invalidarse.

### 7.4 Vulnerabilidades de configuración que amplían el alcance

Estas condiciones no son consecuencia de la filtración; son puertas que ya estaban
abiertas y que facilitaron tanto el ataque original como cualquier ataque posterior.

**a) Documentación Swagger pública en producción.** En `src/main.ts`,
`SwaggerConfig.setup(app)` se invoca sin ninguna condición sobre `NODE_ENV`. La
documentación completa de la API —incluido el endpoint de creación de administradores y el
nombre de su header— está publicada en `https://andes.api.andes-workforce.com/api/docs`.

**b) `FilesController` sin ningún guard de autenticación.** La clase
`src/files/files.controller.ts` no declara `@UseGuards` en ningún punto. Los endpoints
siguientes aceptan cargas **sin autenticación**:

```
POST /api/files/upload/image/:type
POST /api/files/upload/pdf
POST /api/files/upload/video
POST /api/files/upload/images
```

El parámetro `folder` proviene del body sin validación, y el método `uploadFile()` acepta
además un `explicitKey`. Esto permitía escribir en cualquier prefijo del bucket y
sobreescribir objetos existentes.

**c) Webhook de SignWell sin validación.** `POST /api/webhooks/signwell`
(`src/admin/webhooks.controller.ts`) no valida firma ni origen. Permite inyectar eventos
de firma falsos y marcar contratos como firmados.

**d) Panel `adminer` desplegado en producción desde hace 2 meses.** Interfaz web de
administración de PostgreSQL en la misma red Docker que la base de datos. Si Traefik la
expone en algún subdominio, constituye una ruta de acceso directa a `andes_prod`
únicamente con la contraseña filtrada. **Pendiente de verificar.**

**e) Credenciales de AWS inyectadas en el contenedor `db_prod`.** El contenedor de
PostgreSQL recibe `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` sin necesitarlas,
ampliando el radio de explosión sin beneficio funcional.

**f) Objetos de S3 servidos mediante URL pública sin firmar.** Ver sección 3.3.

**g) Ausencia de backups independientes de la cuenta de AWS.** Según el correo, los
backups residían en el mismo entorno comprometido (`andes-backups-private`), por lo que
fueron destruidos con el resto.

---

## 8. Cuantificación — consultas pendientes de ejecución

Los números exactos son requisito para el informe legal y para determinar el alcance de la
notificación. Ejecutar desde:

```bash
docker exec -it db_prod psql -U andesworkforce -d andes_prod
```

### 8.1 Personas afectadas y categorías de datos

```sql
-- Total de personas registradas
SELECT COUNT(*) AS total FROM "Usuario";

-- Desglose por rol
SELECT rol, COUNT(*) FROM "Usuario" GROUP BY rol ORDER BY 2 DESC;

-- CRÍTICO: contraseñas almacenadas en texto plano
SELECT COUNT(*) FROM "Usuario"
 WHERE contrasena IS NOT NULL AND contrasena NOT LIKE '$2%';

SELECT id, correo FROM "Usuario" WHERE contrasena NOT LIKE '$2%';

-- Personas con datos bancarios expuestos
SELECT COUNT(*) FROM "Usuario"
 WHERE "numeroCuentaBancaria" IS NOT NULL OR "numeroRutaBancaria" IS NOT NULL;

-- Personas con documento de identidad registrado
SELECT COUNT(*) FROM "Usuario"
 WHERE "documentoIdentidad" IS NOT NULL OR documento IS NOT NULL;

-- Personas con fotografía de cédula almacenada en S3
SELECT COUNT(*) FROM "Usuario"
 WHERE "fotoCedulaFrente" IS NOT NULL OR "fotoCedulaDorso" IS NOT NULL;

-- Distribución por país — determina las jurisdicciones aplicables
SELECT COALESCE("paisCodigo", pais, 'DESCONOCIDO') AS pais, COUNT(*)
 FROM "Usuario" GROUP BY 1 ORDER BY 2 DESC;

-- Tokens de restablecimiento de contraseña aún vigentes
SELECT COUNT(*) FROM "Usuario"
 WHERE "passwordResetToken" IS NOT NULL AND "passwordResetExpires" > now();

-- Contratos y documentos firmados
SELECT COUNT(*) FROM "ProcesoContratacion";
SELECT COUNT(*) FROM "ProcesoContratacion"
 WHERE "documentoFirmado" IS NOT NULL OR "contratoFinalUrl" IS NOT NULL;

-- Firmas electrónicas: tokens y estado
SELECT estado, COUNT(*) FROM "SignatureRecipient"
 WHERE "signToken" IS NOT NULL GROUP BY estado;

-- Imágenes de firma manuscrita almacenadas
SELECT COUNT(*) FROM "SignatureRecipient" WHERE "signatureImageUrl" IS NOT NULL;

-- Volumen de nómina y facturación expuesto
SELECT COUNT(*) FROM "Nomina";
SELECT COUNT(*) FROM "PaymentInbox";
SELECT COUNT(*) FROM "Empresa";
```

### 8.2 Auditoría de cuentas administradoras

```sql
SELECT id, correo, rol, roles, "fechaCreacion", "fechaActualizacion", activo
  FROM "Usuario"
 WHERE rol IN ('ADMIN','EMPLEADO_ADMIN','ADMIN_RECLUTAMIENTO')
    OR 'ADMIN' = ANY(roles)
 ORDER BY "fechaCreacion" DESC;
```

Cualquier cuenta cuya `fechaCreacion` no corresponda a una alta conocida por el equipo
debe considerarse creada por el atacante mediante la cadena descrita en 7.2.

### 8.3 Inventario de archivos perdidos en S3

```sql
COPY (
  SELECT 'fotoCedulaFrente' AS campo, correo AS titular, "fotoCedulaFrente" AS url
    FROM "Usuario" WHERE "fotoCedulaFrente" IS NOT NULL
  UNION ALL SELECT 'fotoCedulaDorso', correo, "fotoCedulaDorso"
    FROM "Usuario" WHERE "fotoCedulaDorso" IS NOT NULL
  UNION ALL SELECT 'curriculum', correo, curriculum
    FROM "Usuario" WHERE curriculum IS NOT NULL
  UNION ALL SELECT 'videoPresentacion', correo, "videoPresentacion"
    FROM "Usuario" WHERE "videoPresentacion" IS NOT NULL
  UNION ALL SELECT 'fotoPerfil', correo, "fotoPerfil"
    FROM "Usuario" WHERE "fotoPerfil" IS NOT NULL
  UNION ALL SELECT 'documentoFirmado', "nombreCompleto", "documentoFirmado"
    FROM "ProcesoContratacion" WHERE "documentoFirmado" IS NOT NULL
  UNION ALL SELECT 'contratoFinalUrl', "nombreCompleto", "contratoFinalUrl"
    FROM "ProcesoContratacion" WHERE "contratoFinalUrl" IS NOT NULL
  UNION ALL SELECT 'archivoFirmadoUrl', titulo, "archivoFirmadoUrl"
    FROM "SignatureDocument" WHERE "archivoFirmadoUrl" IS NOT NULL
) TO '/tmp/inventario_s3_perdido.csv' WITH CSV HEADER;
```

Consultar además la tabla `S3CleanupBackup`, cuyo campo JSON `filesToDelete` contiene
inventarios históricos de objetos del bucket.

### 8.4 Verificación en AWS CloudTrail — prioridad máxima

Es el dato pendiente más importante: determina la fecha del acceso, la IP de origen, las
operaciones ejecutadas y si los buckets fueron efectivamente eliminados.

```bash
# Actividad general de la cuenta
aws cloudtrail lookup-events --max-results 200 --region us-east-2 \
  --query 'Events[*].[EventTime,EventName,Username,SourceIPAddress]' --output table

# Eliminación de buckets
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteBucket \
  --region us-east-2

# Actividad sobre el bucket principal
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=ResourceName,AttributeValue=andes-workforce-s3 \
  --region us-east-2

# Último uso de la credencial comprometida
aws iam get-access-key-last-used --access-key-id AKIAYTMVPPU4DW4Y3LGB
```

Ejecutar desde una estación de trabajo limpia, no desde el servidor de producción, y con
una credencial distinta de la comprometida.

---

## 9. Plan de remediación

### 9.1 Preservación de evidencia — antes de cualquier cambio

- **No reiniciar el servidor.** Un reinicio destruye procesos en memoria, conexiones
  activas y el estado de `/proc`, que es la evidencia forense de mayor valor.
- Tomar un snapshot del disco en el proveedor de infraestructura.
- Ejecutar el triage de solo lectura del host (script `triage-servidor.sh`) para
  determinar si existió compromiso del servidor: logins exitosos, claves SSH autorizadas,
  persistencia vía cron o systemd, procesos con binario eliminado, `docker diff` sobre los
  contenedores.
- Conservar los logs de fail2ban, `auth.log`, `journalctl` y los logs de los contenedores
  antes de cualquier rotación de logs.

### 9.2 Rotación de credenciales — el orden importa

Rotar la credencial de AWS sin rotar el `JWT_SECRET` deja al atacante con acceso a la
aplicación.

| Orden | Acción |
|---|---|
| 1 | Desactivar `AKIAYTMVPPU4DW4Y3LGB`. Crear credencial nueva con política restringida a un único bucket (no `Resource: "*"`). Revisar en IAM si la credencial tenía permisos ajenos a S3. |
| 2 | Rotar `JWT_SECRET` — invalida todas las sesiones, incluidas las forjadas |
| 3 | Rotar `SECRET_KEY_ADMIN_CREATOR` y auditar la lista de administradores (8.2) |
| 4 | Rotar contraseñas de PostgreSQL y Redis |
| 5 | Cuenta `rromero@teamandes.com`: cambiar contraseña, activar MFA obligatorio y **revisar reglas de reenvío del buzón** (una regla de forwarding oculta es el mecanismo de persistencia habitual en compromiso de correo) |
| 6 | Rotar el Client Secret de Office 365 y revisar los permisos concedidos a la aplicación |
| 7 | Rotar API Key de Resend y token de Cloudflare |
| 8 | Invalidar todos los `signToken` de `SignatureRecipient` no consumidos |
| 9 | Forzar restablecimiento de contraseña a todos los usuarios, empezando por los que la tienen en texto plano |

La rotación implica reinicio de los contenedores: habrá una interrupción breve del
servicio y todos los usuarios deberán volver a iniciar sesión.

### 9.3 Correcciones de código imprescindibles antes de reabrir

| # | Corrección | Archivo |
|---|---|---|
| 1 | Condicionar Swagger a `NODE_ENV !== 'production'` | `src/main.ts` |
| 2 | Añadir guards de autenticación y autorización a `FilesController`; validar `folder` contra una lista blanca; eliminar `explicitKey` del flujo público | `src/files/files.controller.ts`, `files.service.ts` |
| 3 | Eliminar el fallback de comparación de contraseñas en texto plano; migrar las contraseñas afectadas mediante restablecimiento forzado | `src/auth/auth.service.ts` |
| 4 | Validar firma y origen en el webhook de SignWell | `src/admin/webhooks.controller.ts` |
| 5 | Retirar las credenciales de AWS del contenedor `db_prod` | `docker-compose.yml` |
| 6 | Sustituir URLs públicas de S3 por URLs firmadas con expiración; bloquear el acceso público del bucket | `src/files/files.service.ts` |
| 7 | Retirar `adminer` de producción o restringirlo a acceso por túnel SSH | `docker-compose.yml` |
| 8 | Migrar las credenciales a un gestor de secretos; eliminar los `.env` del servidor y verificar que no estén versionados en Git | — |

### 9.4 Endurecimiento de infraestructura

- Ampliar fail2ban: `banTime` incremental, jail `recidive`, cobertura de la capa web
  (Traefik) además de SSH
- Activar versionado y MFA Delete en los buckets de S3
- Configurar backups en una cuenta de AWS distinta, o con un proveedor distinto
- Habilitar CloudTrail con retención prolongada y alertas sobre operaciones destructivas
- Aplicar principio de menor privilegio a las políticas IAM
- Revisar y restringir la lista de orígenes CORS en `src/main.ts`, que incluye entradas de
  desarrollo y direcciones IP obsoletas

---

## 10. Consideraciones legales y de notificación

**Este apartado describe hechos relevantes para el análisis legal. No constituye asesoría
jurídica y la determinación de obligaciones debe hacerla un profesional especializado.**

Elementos fácticos a considerar:

- Las categorías de datos afectadas incluyen datos financieros (cuenta y ruta bancaria),
  documentos de identidad, fecha de nacimiento, domicilio y credenciales de acceso —
  algunas en texto plano.
- Existen personas afectadas en múltiples jurisdicciones. El archivo
  `src/common/helper/countries.helper.ts` contempla, entre otros, España, Portugal,
  Francia, Alemania, Italia y Reino Unido, además de la mayoría de países de Latinoamérica
  y Estados Unidos. La distribución real se obtiene con la consulta de la sección 8.1.
- Si hay residentes de la Unión Europea afectados, el RGPD establece un plazo de
  notificación a la autoridad de control de 72 horas desde el conocimiento de la brecha.
- En Colombia aplica la Ley 1581 de 2012 y el reporte a la Superintendencia de Industria y
  Comercio.
- En Estados Unidos las obligaciones varían por estado y la presencia de datos financieros
  suele activar requisitos específicos.

Acciones recomendadas de forma inmediata:

1. Contratar asesoría legal especializada en protección de datos **hoy**, dado el plazo de
   72 horas potencialmente aplicable.
2. Contratar un equipo de respuesta a incidentes (IR) para la investigación forense.
3. Abrir un caso con AWS Support en severidad crítica.
4. Evaluar la cobertura de la póliza de ciberseguridad, si existe.
5. **No establecer contacto con los extorsionadores** sin la dirección de asesoría legal.
   El correo recibido recomienda involucrar a "Breach Counsel" — es una técnica habitual
   para encauzar la negociación hacia el pago.

---

## 11. Estado de la investigación

### Confirmado

- Las credenciales de AWS estaban en texto plano en el servidor y en las variables de
  entorno de los contenedores
- La credencial tenía capacidad de enumerar todos los buckets de la cuenta y de eliminar
  objetos
- El bucket servía objetos mediante URLs públicas sin firmar
- Existen contraseñas almacenadas en texto plano en la base de datos
- El endpoint de creación de administradores está protegido solo por una clave estática
  filtrada
- La documentación completa de la API está publicada en producción
- Los endpoints de carga de archivos no requieren autenticación
- Los endpoints públicos de firma electrónica operan solo con tokens que fueron
  exfiltrados
- Los intentos de acceso SSH registrados por fail2ban no resultaron en acceso exitoso

### Pendiente de verificación

| # | Pendiente | Método |
|---|---|---|
| 1 | Fecha, hora e IP de origen del acceso a AWS | CloudTrail (8.4) |
| 2 | Confirmación de que los tres buckets fueron efectivamente eliminados | Consola de S3 con credencial alterna |
| 3 | Si la credencial IAM tenía permisos fuera de S3 | Consola IAM |
| 4 | Si el servidor de producción fue comprometido | Triage forense del host (9.1) |
| 5 | Existencia de cuentas administradoras creadas por el atacante | Consulta 8.2 |
| 6 | Si `adminer` estaba expuesto públicamente a través de Traefik | Etiquetas de Traefik en `docker-compose.yml` |
| 7 | Si las credenciales fueron versionadas en el repositorio Git y si este es público | `git log -S`, `git ls-files`, revisión del remoto |
| 8 | Política de acceso público del bucket (previa a su eliminación) | CloudTrail |
| 9 | Número exacto de personas afectadas por categoría de dato | Consultas 8.1 |
| 10 | Alcance de los permisos concedidos a la aplicación de Office 365 | Portal de Azure / Entra ID |

### Preguntas abiertas

1. ¿Existe algún backup de la base de datos o de los archivos fuera de la cuenta de AWS
   comprometida?
2. ¿La cuenta `rromero@teamandes.com` tenía MFA activo?
3. ¿El repositorio de código es público o privado, y en qué momento se incorporaron las
   credenciales al historial?
4. ¿Hay una póliza de ciberseguridad vigente?
5. ¿Quiénes tienen acceso administrativo a la cuenta de AWS y al servidor?

---

## 12. Anexo — evidencia recopilada

### Comandos utilizados en la investigación

```bash
# Localización de la aplicación y del proceso
ps aux | grep -i "node\|nest\|api"
pwdx <pid>

# Extracción de variables de entorno del proceso (evidencia principal)
cat /proc/<pid>/environ | tr '\0' '\n' | sort

# Variables de entorno de los contenedores
docker ps
docker inspect <container> --format='{{json .Config.Env}}'

# Localización de archivos de configuración
find / -name ".env" -o -name ".env*" 2>/dev/null

# Estado de fail2ban
fail2ban-client status
fail2ban-client status sshd
grep -E "Ban|Unban" /var/log/fail2ban.log
```

### Archivos de código analizados

```
prisma/schema.prisma                          (60 modelos, 56 KB)
src/main.ts                                   (bootstrap, CORS, Swagger)
src/app.module.ts                             (módulos globales)
src/app.controller.ts, src/app.service.ts     (endpoints sin guard)
src/config/upload.config.ts                   (prefijos de S3)
src/config/environments.config.ts             (mapeo de variables)
src/config/swagger.config.ts                  (publicación de la documentación)
src/files/files.service.ts                    (operaciones sobre S3, URLs públicas)
src/files/files.controller.ts                 (endpoints de carga sin guard)
src/s3-cleanup/s3-cleanup.service.ts          (borrado de objetos, cron)
src/auth/auth.service.ts                      (fallback de contraseña en texto plano)
src/auth/auth.module.ts                        (configuración de JWT)
src/usuarios/usuarios.controller.ts           (creación de administradores)
src/common/guards/admin-creator.guard.ts      (validación por header estático)
src/esign/esign.controller.ts                 (endpoints públicos de firma)
src/admin/webhooks.controller.ts              (webhook sin validación)
src/admin-hub/**                              (módulos de nómina y facturación)
```

### Correo de extorsión — datos relevantes

- Remitente autodenominado: "ETHICS TEAM"
- Destinatario: Sr. Rendón
- Plazo: 72 horas
- Canal de contacto: dirección `.onion` con usuario y contraseña proporcionados
- Afirma haber descargado: bucket `andes-workforce-s3` (14.252 objetos / 83,8 GB, 2.497
  PDFs firmados, 179 contratos, 1.063 videos), base de datos PostgreSQL de producción
  (`users_prod`, `events_prod`), ClickHouse `pulse_analytics` (7.758.077 registros) y
  backups de base de datos con configuración, secretos y claves de acceso
- Afirma haber destruido: `andes-workforce-s3` (14.562 versiones de objeto),
  `andes-backups-private` (8 backups) y `dev-test-andesworkforce`
- Afirma que no existe recuperación posible: versionado suspendido, versiones purgadas, sin
  backups independientes

**Nota:** el correo menciona una instancia de ClickHouse (`pulse_analytics`) que no aparece
en la infraestructura documentada del servidor de producción. Debe verificarse si existe en
otro entorno o si se trata de una imprecisión del atacante — un indicio relevante para
evaluar la credibilidad del resto de sus afirmaciones.

---

*Documento en revisión continua. Actualizar conforme se resuelvan los puntos de la
sección 11.*
