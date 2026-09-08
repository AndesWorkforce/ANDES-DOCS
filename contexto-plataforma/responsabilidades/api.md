# API-ANDES — responsabilidad backend

**Repo:** `API-ANDES`  
**Stack:** NestJS 11, Prisma 6, PostgreSQL, JWT, BullMQ/Redis, AWS S3, Swagger, pnpm  
**Qué es:** la fuente de verdad del negocio Andes. Andy piensa aquí. Chatwoot solo le entrega mensajes.

Puerto por defecto en código: `PORT=3000`. En **test** el proceso PM2 suele escuchar en **3001** detrás de Nginx.

---

## Dueño de

Módulos en `src/app.module.ts`:

| Módulo | Responsabilidad |
|---|---|
| `AuthModule` + `MfaModule` | Login, JWT, MFA admin |
| `UsuariosModule` / `UsersModule` | Perfil, contrato actual, roles |
| `CompaniesModule` | Empresas cliente |
| `OffersModule` | Ofertas |
| `ApplicationsModule` | Postulaciones |
| `AdminModule` | Operación interna (incluye piezas de Admin Hub) |
| `FilesModule` | Upload y lectura vía S3 |
| `EmailModule` / `EmailTemplatesModule` | Correos transaccionales |
| `NotificationsModule` | Avisos in-app |
| `HolidaysModule` | Feriados / calendario |
| `EsignModule` | Firma electrónica (flag `ENABLE_ESIGN`) |
| `S3CleanupModule` | Limpieza de objetos |
| `ChatModule` | Cerebro de Andy |
| `ChatwootModule` | Identity HMAC, webhook, sendReply, handoff |
| `PrismaModule` | Acceso a Postgres Andes |
| BullMQ | Colas (si Redis está configurado) |

También: rate limit HTTP global (`ThrottlerGuard`) y rate limit específico de chat (memoria de proceso).

---

## No es dueño de

- HTML/CSS ni el SDK del widget.
- Inbox, asignación de agentes ni historial largo de chat (Chatwoot).
- Certificados TLS (Traefik/Nginx).
- Postgres/Redis **de Chatwoot** (stack aparte).

---

## Andy — superficie HTTP

| Método | Ruta | Auth | Para qué |
|---|---|---|---|
| `POST` | `/chat` | JWT + contrato activo | Fallback BFF |
| `POST` | `/chatwoot/webhook` | Firma HMAC Chatwoot | Mensajes del widget |
| `GET` | `/chatwoot/identity` | JWT + contrato activo | Hash para `setUser` |
| `POST` | `/chatwoot/guest-identity` | throttle | Visitante |
| `GET` | `/chatwoot/conversations` | JWT + contrato | Hilos abiertos |
| `POST` | `/chatwoot/restart-session` | JWT + contrato | Nuevo tema |
| `POST` | `/chatwoot/guest-restart` | throttle | Nuevo tema guest |

`ChatService.complete()` es el único orquestador de texto (estático o LLM).  
`ChatwootService.handleWebhook()` resuelve usuario, rate limit, llama a `complete` y `sendReply`.

Knowledge: `src/chat/knowledge/*.md` + `pnpm sync:chat-knowledge`.

---

## Configuración (keys, sin valores)

Obligatorias de plataforma: `DATABASE_URL`, `JWT_SECRET`, `MFA_ENCRYPTION_KEY`, S3, `DOMAIN`, `SECRET_KEY_ADMIN_CREATOR`.

Andy (off por defecto):

- `CHAT_ENABLED`, `CHAT_PROVIDER` (`openai` \| `groq`), `CHAT_API_KEY`, `CHAT_MODEL`, `CHAT_MAX_TOKENS`
- Rate: `CHAT_RATE_LIMIT_*`
- Chatwoot: `CHATWOOT_ENABLED`, `CHATWOOT_BASE_URL`, `CHATWOOT_ACCOUNT_ID`, `CHATWOOT_BOT_TOKEN`, `CHATWOOT_WEBHOOK_SECRET`, teams, opcional `CHATWOOT_API_TOKEN` (no usar el bot token para crear contactos)

Prod Andy: OpenAI `gpt-4o-mini`. Test: Groq está bien.

En Docker prod, `CHATWOOT_BASE_URL` debe ser el hostname interno (`http://chatwoot_prod:3000`), no la URL pública.

---

## Deploy

| Entorno | Trigger | Script |
|---|---|---|
| Prod | push `master` | `.github/workflows/deploy.yml` → `./deploy_api.sh` |
| Test | scripts en el host (`deploy_api_test.sh` / PM2 restart) | no hay `deploy-test.yml` en el árbol actual de API |

Migraciones: `pnpm db:migrate` (`prisma migrate deploy`). Nunca `docker compose down -v` en prod.

Análisis largo (enero 2026): `ANDES-DOCS/admin-hub/ANALISIS_COMPLETO_API_ANDES.md`.
