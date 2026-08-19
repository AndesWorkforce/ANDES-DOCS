# Reconexión S3 post-incidente (11 ago 2026)

Checklist operativo para que el sistema de guardado vuelva a funcionar con buckets **privados** y credenciales nuevas.

## Por qué ves estos síntomas

| Síntoma | Causa real |
|---|---|
| XML `AccessDenied` al abrir `https://…amazonaws.com/images/….jpeg` | El bucket está privado (correcto). El código guardaba URLs públicas sin firmar. El navegador no tiene permiso. |
| Toast «Error de red al subir el video» | El cliente hace `PUT` directo a S3. Sin **CORS** en el bucket nuevo, el navegador aborta con `xhr.onerror`. |
| Cambiaste `.env` y «no cambia nada» | `docker restart` **no** recarga `env_file`. Hay que **recrear** el contenedor. |

## 1. IAM (credencial nueva)

Política mínima (reemplaza `BUCKET`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListBucket",
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetBucketLocation"],
      "Resource": "arn:aws:s3:::BUCKET"
    },
    {
      "Sid": "ObjectRW",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ],
      "Resource": "arn:aws:s3:::BUCKET/*"
    }
  ]
}
```

- **No** uses `Resource: "*"` ni `s3:ListAllMyBuckets` / `s3:ListBuckets`.
- Desactiva la access key comprometida (`AKIAYTMVPPU4DW4Y3LGB`).

## 2. Bucket: privado + CORS + Block Public Access

1. Block Public Access: **todo ON**.
2. CORS del bucket (consola S3 → Permissions → CORS):

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "HEAD"],
    "AllowedOrigins": [
      "https://andesworkforce.com",
      "https://www.andesworkforce.com",
      "http://localhost:3000"
    ],
    "ExposeHeaders": ["ETag", "x-amz-request-id"],
    "MaxAgeSeconds": 3000
  }
]
```

Sin este CORS, el upload de video por URL firmada falla con «Error de red». El cliente ahora tiene fallback por API, pero CORS sigue siendo necesario para subidas grandes eficientes.

## 3. Variables en el servidor

Archivo: `~/app/api/.env` (el que usa `env_file` de `api_prod`):

```bash
AWS_REGION=us-east-2
AWS_S3_BUCKET=andes-workforce-s3   # o el nombre real del bucket nuevo
AWS_ACCESS_KEY_ID=AKIA…           # key NUEVA
AWS_SECRET_ACCESS_KEY=…           # secret NUEVO
```

Verificar que el contenedor las tiene (no solo el archivo):

```bash
# MAL: no recarga env
docker restart api_prod

# BIEN: recrea con el env_file actualizado
cd ~/app
docker compose -f docker-compose.prod.yml up -d --force-recreate --no-deps api

# Confirmar
docker exec api_prod printenv | grep -E 'AWS_'
# Debe mostrar la key nueva (primeros caracteres) y el bucket correcto
```

Si el cliente Next tiene `NEXT_PUBLIC_*` cambiados, además hay que **rebuild** (van en build-args):

```bash
docker compose -f docker-compose.prod.yml build --no-cache client
docker compose -f docker-compose.prod.yml up -d --force-recreate client
```

## 4. Probar la API

```bash
curl -s https://andes.api.andes-workforce.com/api/files/test-connection | jq
```

Esperado: `"status": "success"` (hace `headBucket` + put/delete de sonda).

Ver un objeto ya subido (redirect a URL firmada):

```
https://andes.api.andes-workforce.com/api/files/content?url=https://BUCKET.s3.us-east-2.amazonaws.com/images/UUID.jpeg
```

Abrir esa URL en el navegador: debe mostrar la imagen (302 → URL firmada).

## 5. Qué cambió en el código

### API (`FilesService` / `FilesController`)
- Diagnóstico sin `listBuckets` (menor privilegio).
- Errores AWS más explícitos en logs.
- Nuevo `GET /files/content?url=…|key=…` para servir objetos de buckets privados (redirect firmado o stream).

### Cliente
- Helper `toAccessibleMediaUrl()` → reescribe URLs S3 a `/files/content`.
- Perfil (foto, cédula, PC specs, video) usa el helper.
- `VideoModal`: si el PUT directo a S3 falla (CORS), reintenta por `POST /files/upload/video`.

## 6. Assets de marketing del sitio

Páginas públicas (about, team, home) siguen hardcodeando URLs a `andes-workforce-s3`. Esas imágenes **hay que re-subirlas** al bucket nuevo (o usar CloudFront). Mientras el bucket sea privado, esas URLs públicas seguirán en Access Denied. Opciones:

1. Prefijo `images/page_andesworkforce/**` y `team/**` con política de lectura pública **solo** para marketing (no para cédulas/contratos), o
2. Servir marketing desde el repo / CDN aparte.

No abras todo el bucket otra vez.

## 7. Orden de despliegue recomendado

1. IAM + CORS + Block Public Access en AWS.
2. Actualizar `~/app/api/.env`.
3. `force-recreate` de `api`.
4. `curl …/files/test-connection`.
5. Desplegar API + Client con este código.
6. Probar upload de imagen/video en perfil y apertura vía `/files/content`.
