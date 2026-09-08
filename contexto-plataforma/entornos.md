# Entornos

Fuente de verdad de **dónde corre qué**. No incluye secretos.

**Fecha de este recorte:** 8 de septiembre de 2026.

---

## Vista rápida

| | Local | Test / desarrollo | Producción |
|---|---|---|---|
| Host | tu máquina | `2.24.196.222` | `147.93.44.202` (`srv785336`) |
| Cómo corre CLIENT + API | `pnpm dev` | PM2 + Nginx | Docker Compose + Traefik |
| Sitio | `http://localhost:3000` | host del servidor test | `https://andesworkforce.com` |
| API pública | `http://localhost:8001` o el `PORT` del `.env` | `http://2.24.196.222/api/` (Nginx → Nest) | `https://andes.api.andes-workforce.com` |
| Chatwoot | `http://localhost:3030` | `:3030` o reverse proxy | `https://chat.andes-workforce.com` |
| Webhook Andy | `http://host.docker.internal:<API>/api/chatwoot/webhook` | `http://2.24.196.222/api/chatwoot/webhook` | `https://andes.api.andes-workforce.com/api/chatwoot/webhook` |
| Deploy | manual | GitHub Actions test (CLIENT: rama `test-development`) | push a `master` → `deploy_api.sh` / `deploy_client.sh` |

El puerto local de la API **no está unificado en todos los docs**: aparece `8001` (Chatwoot local) y `3000` (default Nest). Usa el `PORT` real de `API-ANDES/.env`.

---

## Local

| Pieza | Cómo | Puerto típico |
|---|---|---|
| CLIENT-ANDES | `pnpm dev` | 3000 |
| API-ANDES | `pnpm start:dev` | 8001 o 3000 |
| Chatwoot | `CHATWOOT-LOCAL` → `docker compose up -d` | 3030 |
| Postgres Andes | local o Docker propio | 5432 |
| Redis | local, BullMQ | 6379 |

Knowledge base:

```bash
cd API-ANDES
pnpm sync:chat-knowledge
```

---

## Test (`2.24.196.222`)

Stack **no Docker** para CLIENT/API: procesos PM2 detrás de Nginx.

| Pieza | Ruta / proceso | Puerto |
|---|---|---|
| CLIENT | `/var/www/cliente-principal/CLIENT-ANDES` · PM2 `cliente-principal` o `client-andes-test` | 3000 |
| API | `/var/www/cliente-principal/API-ANDES` · PM2 `api-andes` o `api-andes-test` | 3001 |
| Chatwoot | `/var/www/cliente-principal/chatwoot-test/` o `/var/www/chatwoot-test` | 3030 |
| Postgres Andes | local en el host | 5432 |

Nginx (sitio `andes`) debe mandar el BFF de Next **antes** que el catch-all de la API:

```nginx
location ~ ^/api/chatwoot/(identity|conversations) { proxy_pass http://localhost:3000; ... }
location /api/chat/ { proxy_pass http://localhost:3000; ... }
location /api/ { proxy_pass http://localhost:3001; ... }
```

Usuarios del host: `sysadmin`, `david` (sudo). Owner habitual de repos: `webuser`.

Scripts de deploy test (CLIENT): `/home/sysadmin/deploy_client_test.sh` (workflow `deploy-test.yml`).

---

## Producción (`147.93.44.202`)

Stack **Docker**. Archivo principal: `~/app/docker-compose.prod.yml`.

| Contenedor | Dominio | Red |
|---|---|---|
| `client_prod` | `andesworkforce.com`, `www.andesworkforce.com` | `web` |
| `api_prod` | `andes.api.andes-workforce.com` | `web` + `internal` |
| `db_prod` | no público | `internal` |
| `redis_prod` | no público | `internal` |
| `adminer_prod` | `db.andes-workforce.com` (BasicAuth) | `web` + `internal` |
| `traefik` | 80/443 | `web` |
| Chatwoot (`chatwoot_prod`, kit Andy) | `chat.andes-workforce.com` | `web` (API lo llama por nombre interno) |
| Grafana | `grafana.andes-workforce.com` | stack `~/monitoring/` |

Rutas **viejas de PM2** (`/var/www/backend`, `/var/www/frontend`, apps `nest-api` / `andes-client`) son el inventario de abril 2026, **antes** del corte a Docker. No las uses como runtime actual.

Código de prod: rama `master`. `NEXT_PUBLIC_*` se hornea en el **build** del client; cambiar el widget exige rebuild.

Blue-green (archivos en `ANALISIS_ANDES_PROD/`): listo para implementar, no es el diagrama de “así corre hoy” salvo que el servidor ya tenga `docker-compose.blue.yml` activo.

Kubernetes (`KUBERNETES/`): plan, no producción.

---

## DNS (Hostinger)

Dominio operativo: `andes-workforce.com` / `andesworkforce.com`.  
IP prod: `147.93.44.202`.

Registros relevantes documentados: sitio, API, `chat`, `grafana`, Adminer `db`.

---

## Flags de Andy (todos los entornos)

| Variable | Dónde | Efecto |
|---|---|---|
| `CHAT_ENABLED` | API | Apaga `ChatService` |
| `CHATWOOT_ENABLED` | API | Apaga webhook / identity Chatwoot |
| `NEXT_PUBLIC_CHATWOOT_ENABLED` | CLIENT (build) | Apaga el widget; contratista puede caer a BFF |

Kill switch: los tres en `false` + rebuild del client. El código puede quedarse; Admin Hub no cambia.
