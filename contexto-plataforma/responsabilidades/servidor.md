# Servidor — responsabilidad de runtime

El host no implementa negocio. Corre procesos, proxy, firewall y discos.

Hay **dos runtimes distintos**. No mezclar IPs ni stacks.

---

## Test — `2.24.196.222`

**Modelo:** Ubuntu + Nginx + PM2 + Postgres/Redis en el host + Chatwoot en Docker.

| Pieza | Cómo |
|---|---|
| OS | Ubuntu (docs de setup hablan 25.10; verificar `lsb_release` si hace falta) |
| Usuarios | `sysadmin`, `david` (sudo); repos a menudo de `webuser` |
| SSH | clave pública, root login off, passwords off (objetivo) |
| UFW | 22, 80, 443; 3030 solo si se acepta exponer Chatwoot |
| CLIENT | PM2 puerto **3000** en `/var/www/cliente-principal/CLIENT-ANDES` |
| API | PM2 puerto **3001** en `/var/www/cliente-principal/API-ANDES` |
| Nginx | sitio `andes`: BFF chat → 3000; `/api/` → 3001 |
| Chatwoot | `docker compose` en `chatwoot-test`, puerto 3030 |

Comandos habituales:

```bash
pm2 status
pm2 logs api-andes
pm2 restart api-andes
pm2 restart cliente-principal
cd /var/www/cliente-principal/chatwoot-test && sudo docker compose ps
```

Ownership si Git se queja:

```bash
sudo chown -R webuser:webuser /var/www/cliente-principal/API-ANDES
sudo chown -R webuser:webuser /var/www/cliente-principal/CLIENT-ANDES
```

**No uses** `SERVIDOR_DESAROLLO/CONTEXTO_SERVIDOR.md` como checklist actual: mezcla puertos (API 3000 / client 3001 al revés del test real), rutas `~/apps/` y un “pendiente NVM” que ya no describe el servidor vivo.

Fuente Andy en test: `SERVIDOR_DESAROLLO/ANDI_CHATBOT_TEST_SERVER.md`.

---

## Producción — `147.93.44.202`

**Modelo (mayo 2026 en adelante):** un servidor Ubuntu 24.04, 4 vCPU EPYC, 15 GiB RAM, Docker Compose + Traefik v3.

```
~/app/
├── docker-compose.prod.yml
├── traefik/ + letsencrypt/
├── api/          Dockerfile + .env
├── client/       Dockerfile + .env
└── chatwoot/     kit Andy (si ya se montó)
```

| Responsabilidad del host | Detalle |
|---|---|
| Proxy / TLS | Traefik, Let's Encrypt, HTTP→HTTPS, www→apex |
| Aislamiento | red `web` (público vía Traefik) vs `internal` (db + redis) |
| Persistencia | volúmenes `db_data`, `redis_data` — **nunca** `compose down -v` |
| Backup | `backupuser` / `backup_andes.sh` — confirmar cron (históricamente no había crontab) |
| Monitoreo | `~/monitoring/` Prometheus + Grafana + cAdvisor + exporters |

UFW: 22, 80, 443; 5432 solo `10.0.0.0/8` si aún aplica. Cerrar 25 SMTP si no se usa.

Usuarios: `sysadmin` (operación), `david`, `fernando`, `mateo`, `ubuntu`. Servicio: `webuser` (legado PM2), `backupuser`.

Comandos:

```bash
cd ~/app && docker compose -f docker-compose.prod.yml ps
docker logs -f api_prod
docker logs -f client_prod
docker compose -f docker-compose.prod.yml restart api
```

Inventario pre-Docker (abril 2026, PM2 `nest-api` / `andes-client` en `/var/www/backend|frontend`): `SERVIDOR_DESAROLLO/INVENTARIO_SERVIDOR_PROD_2026-04-29.md`. Sirve como arqueología, no como mapa actual.

Contexto Docker: `SERVIDOR_DESAROLLO/CONTEXTO_SERVIDOR_PRODUCCION.md`.

---

## Pendientes de infra (no secretos)

Documentados y aún abiertos en varios informes:

- Confirmar `PermitRootLogin` endurecido (el inventario de abril lo tenía en `yes`).
- Coolify en `/data/coolify/` — ¿sigue vivo?
- Cron real de backups de Postgres.
- Blue-green: configs en `ANALISIS_ANDES_PROD/` listas; verificar si ya cortaron tráfico.
- Kubernetes: solo plan (`KUBERNETES/`).

---

## Qué no vive en el servidor de app

- DNS: Hostinger (`SERVIDOR_DESAROLLO/GUIA_DNS_HOSTINGER.md`).
- Objetos de usuario: AWS S3 (región típica `us-east-2` en Joi de la API).
- LLM: Groq (test) / OpenAI (prod recomendado).
