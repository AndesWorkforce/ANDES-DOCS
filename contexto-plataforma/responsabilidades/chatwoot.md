# Chatwoot — responsabilidad de la bandeja

Chatwoot es el **canal** (live chat + panel de agentes). No conoce contratos Andes. Self-hosted, no Cloud.

Imagen de montaje prod (kit 2026): `chatwoot/chatwoot:v4.17.1`. **No usar `latest`** sin `db:chatwoot_prepare`.

---

## Dueño de

- Widget SDK en el navegador (`sdk.js` + website token).
- Conversaciones, contactos, adjuntos del hilo.
- Panel de agentes: `chat.andes-workforce.com` (prod) / `:3030` (local y test).
- Equipos **Soporte** y **Marketing** (handoff).
- Agent Bot “Andy”: URL saliente = webhook de la API.
- Postgres y Redis **propios** (no mezclar con `db_prod` / `redis_prod` de Andes).
- Sidekiq (jobs internos de Chatwoot).

---

## No es dueño de

- Texto de las respuestas (API `ChatService`).
- Saber si el usuario tiene contrato activo (la API lo valida en identity y en el webhook).
- Knowledge base ni LLM keys.

---

## Identidad

El widget llama `setUser(identifier, { email, name, custom_attributes })`.

| Tipo | Identifier | Atributos |
|---|---|---|
| Contratista | `user.id` de Andes | `andes_user_id` |
| Guest | `guest:{client\|candidate}:{email}` | `andes_visitor_kind` |

Tras `reset()` (nuevo tema) hay que volver a `setUser`.

HMAC: la API firma el identifier (`GET /chatwoot/identity` o guest).  
`CHATWOOT_BOT_TOKEN` sirve para webhook + `sendReply`. **No** sirve para crear contactos (401). Para sync server-side de contactos hace falta `CHATWOOT_API_TOKEN` de agente; si falta, no es error: el widget identifica igual.

---

## Inbox Website — reglas de test/prod

- `enable_email_collect=false` y pre-chat apagado. Si no, Chatwoot pide correo y puede mezclar un guest con un contratista.
- Bot asignado al inbox Website.
- Dominio del inbox = origen real del sitio (`localhost:3000`, host test, o `https://andesworkforce.com`).

---

## Dónde vive

| Entorno | Compose / ruta | URL widget | Webhook |
|---|---|---|---|
| Local | `CHATWOOT-LOCAL/` | `http://localhost:3030` | `http://host.docker.internal:<PORT_API>/api/chatwoot/webhook` |
| Test | Docker en el host test, p. ej. `/var/www/chatwoot-test` | `:3030` | `http://2.24.196.222/api/chatwoot/webhook` |
| Prod | `~/app/chatwoot` vía `PAQUETE_ANDY_PRODUCCION/chatwoot/` | `https://chat.andes-workforce.com` | `https://andes.api.andes-workforce.com/api/chatwoot/webhook` |

`CHATWOOT-PROD/` es referencia histórica. El paquete canónico de montaje es `PAQUETE_ANDY_PRODUCCION/`.

Tras actualizar la imagen: `db:chatwoot_prepare` + restart rails/sidekiq. Sin eso el widget puede responder 500 (`ai_assignee_type`).

---

## Relación con Traefik / Nginx

- **Prod:** Traefik enruta `Host(chat.andes-workforce.com)` al contenedor Rails. La API habla por red Docker `http://chatwoot_prod:3000`.
- **Test:** el widget suele ir directo al puerto 3030; el webhook entra por Nginx `/api/` → Nest 3001.
