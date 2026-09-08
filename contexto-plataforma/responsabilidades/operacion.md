# Operación — CI/CD, monitoreo y cutover

Responsabilidad de **cómo cambia** el sistema, no de qué calcula.

---

## CI/CD

| Repo | Workflow | Rama | Destino |
|---|---|---|---|
| CLIENT-ANDES | `deploy.yml` | `master` | prod · `./deploy_client.sh` |
| CLIENT-ANDES | `deploy-test.yml` | `test-development` | test `2.24.196.222` · `deploy_client_test.sh` |
| API-ANDES | `deploy.yml` | `master` | prod · `./deploy_api.sh` |

Mecanismo: `appleboy/ssh-action` + secrets `HOST`, `USERNAME`, `SSH_PRIVATE_KEY`, `PORT`. Test CLIENT usa `SSH_PRIVATE_KEY_TEST`.

Prod (Docker) en la práctica: pull/build en `~/app` según el script del host. Blue-green: `ANALISIS_ANDES_PROD/RUNBOOK_BLUE_GREEN.md` cuando ese layout esté activo.

Secrets: nunca en esta carpeta. Solo nombres de variables.

---

## Monitoreo (prod)

Stack en `~/monitoring/` del servidor `147.93.44.202`:

- Prometheus (scrape)
- Grafana → `https://grafana.andes-workforce.com`
- Node Exporter (host)
- cAdvisor (contenedores)
- Métricas Traefik (tráfico)

Docs: `SERVIDOR_DESAROLLO/CONTEXTO_MONITORING_STACK.md`, `SERVIDOR_DESAROLLO/monitoring/`.  
DNS Grafana: `SERVIDOR_DESAROLLO/GUIA_DNS_HOSTINGER.md`.

Test: operación con `pm2 logs` + `docker compose logs` de Chatwoot. No asumir Grafana ahí.

---

## Andy — operación

| Acción | Qué tocar |
|---|---|
| Encender en test | Flags API + CLIENT, rebuild client, Chatwoot up, webhook firmado |
| Apagar sin quitar código | `CHAT_ENABLED=false`, `CHATWOOT_ENABLED=false`, `NEXT_PUBLIC_CHATWOOT_ENABLED=false` + rebuild client |
| Subir a prod | `PAQUETE_ANDY_PRODUCCION/CHECKLIST.md` — Chatwoot primero, API después, client al final (es el momento público) |
| Knowledge | `pnpm sync:chat-knowledge` en API y restart |
| Widget no aparece | flags `NEXT_PUBLIC_*`, contrato activo, Nginx BFF, consola del browser |
| Webhook mudo | URL del bot, `CHATWOOT_WEBHOOK_SECRET`, logs API, red Docker vs host |

LLM prod recomendado: OpenAI `gpt-4o-mini`. Groq: test.

---

## Tickets

Prefijos en `ANDES-DOCS/README.md`: `KAN` producto, `SDT` infra, `RM` marketing.

Soporte IT: portal Jira del equipo (enlace en docs de Andy).

---

## Fuera de alcance de esta carpeta

- Plantillas de PR y commits → `ANDES-DOCS/pr-templates/`, `commit-guide/`
- Historial de PRs → `ANDES-DOCS/pr-history/`
- Informes de incidentes → `ANDES-DOCS/informes/`
- Plan K8s → `KUBERNETES/` (futuro)
