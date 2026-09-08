# Mapa de responsabilidades

Quién es dueño de cada capa. Una fila = una decisión: si falla X, se mira el documento de esa columna.

---

## Matriz

| Capacidad | CLIENT | API | Chatwoot | Proxy / host | Datos |
|---|---|---|---|---|---|
| Sitio público y marketing | Dueño | — | — | Sirve el sitio | — |
| Login, JWT en cookie, roles | UI + cookie `auth_token` | Emite JWT, MFA, guards | Recibe identidad HMAC | — | Usuarios en Postgres Andes |
| Contratos, ofertas, postulaciones | Pantallas | Dueño | — | — | Postgres Andes + S3 |
| Admin Hub (nómina / facturación) | UI `/admin-hub` | Módulos admin | **No monta Andy** | — | Postgres Andes |
| Mostrar el launcher de Andy | `ChatProvider` | Flags `CHAT_*` | Widget SDK | — | Visitante en localStorage |
| Identidad del chat | BFF `/api/chatwoot/*` | HMAC + sync contacto | `setUser` | Nginx test: BFF vs API | — |
| Responder como Andy | Fallback `ChatWidget` | `ChatService` (dueño) | Entrega el mensaje | — | Knowledge `.md` + perfil |
| Handoff a humano | — | Detecta pedido y llama API Chatwoot | Equipos Soporte / Marketing | — | Conversaciones Chatwoot |
| Archivos (CVs, invoices, evidencias) | Upload UI | `FilesModule` | — | — | AWS S3 |
| Colas (emails, jobs) | — | BullMQ | Sidekiq (propio) | — | Redis Andes / Redis Chatwoot |
| TLS y DNS | — | — | Host `chat.*` | Traefik (prod) / Nginx (test) | Let's Encrypt |

---

## Audiencias de Andy

| Audiencia | Cómo entra | Qué puede hacer Andy | Qué no hace |
|---|---|---|---|
| Contratista con contrato activo | Login + `useChatAccess` | Invoice, perfil, pagos, contrato, FAQ interna | Datos de otros usuarios |
| Visitante **client** (quiere contratar) | Formulario guest | Precios, staffing, proceso comercial | Nómina, contratos ajenos |
| Visitante **candidate** (quiere aplicar) | Formulario guest | Vacantes, cómo aplicar | Estado de su postulación (aún) |
| Empresa / Admin / Admin Hub | Sin launcher | — | El chat no se monta en `/admin-hub` |

---

## Dos caminos de chat (misma API)

```
Principal:  Navegador → Chatwoot widget → webhook API → ChatService → sendReply
Reserva:    Navegador → CLIENT /api/chat → API POST /chat → ChatService → JSON
```

Chatwoot se usa si `NEXT_PUBLIC_CHATWOOT_ENABLED=true` y el SDK carga. Si falla, el contratista cae a `ChatWidget`. El visitante guest **solo** tiene Chatwoot; sin SDK vuelve al formulario.

Detalle: [chatbot-andy.md](./responsabilidades/chatbot-andy.md).

---

## Ramas (cuidado al desplegar)

| Entorno | CLIENT | API | Notas |
|---|---|---|---|
| Local | la que estés trabajando | la que estés trabajando | Chatwoot en Docker `:3030` |
| Test `2.24.196.222` | `test-development` (workflow) / históricamente `admin-hub` o `feat/andi-on-admin-hub` | según script del servidor | Un push a `admin-hub` **sin** Andy puede apagar el bot en test |
| Producción | `master` | `master` | Andy a prod = PR a `master` + flags + rebuild client |

Kit de cutover prod: `PAQUETE_ANDY_PRODUCCION/`.
