# Andy — responsabilidad del chatbot

Andy es el asistente de Andes. **El texto lo genera la API.** El client solo abre el canal. Chatwoot solo transporta.

Nombre en UI: Andy. Docs viejos dicen Andi — es el mismo bot.

---

## Dueño de

- Decidir audiencia: contratista autenticado vs guest `client` vs guest `candidate`.
- Capas de respuesta (barato → caro).
- Knowledge base y flujos estáticos de contratista.
- Contexto dinámico de perfil/contrato (Prisma).
- Guardrails: sanitizar historial, bloquear prompts raros, rate limit.
- Fallback BFF si Chatwoot no carga (solo contratista).

---

## Capas de `ChatService` (orden)

| # | Capa | Cuándo | Tokens LLM |
|---|---|---|---|
| 1 | Guard de mensaje | Input peligroso / vacío | 0 |
| 2 | Identidad | “¿quién soy?” en sesión autenticada | 0 |
| 3 | Saludo | Saludo puro | 0 |
| 4 | Flujo estático contratista | invoice, seguridad social, perfil, contrato, pagos | 0 |
| 5 | FAQ estática / out-of-scope | Guest o público, sin contexto de contrato | 0 |
| 6 | LLM | Resto, con system prompt + knowledge recortado | Groq u OpenAI |

Prompts: `CHAT_SYSTEM_PROMPT_CONTRACTOR` / `_CLIENT` / `_CANDIDATE` / `_COMPACT` en `faq-static-responses.ts`.

Si el LLM falla y hay contexto de contratista, se reintenta el matcher de flujos.

---

## Knowledge

| Archivo | Uso |
|---|---|
| `andes-public-knowledge.md` | Sitio público |
| `andes-sales-knowledge.md` | Comercial / cliente guest |
| `andes-contractor-flows.md` | Operación del contratista |
| `faq-static-responses.ts` | Hits sin LLM |

Sincronizar desde páginas del CLIENT (excluye `/admin`):

```bash
cd API-ANDES
pnpm sync:chat-knowledge
```

`KnowledgeBaseService` recorta el prompt (~36k contratista / ~28k público) y deja el `.md` completo en disco.

---

## Rate limit

`ChatRateLimitService` — **memoria del proceso API** (no Redis). Con varias réplicas los contadores no se comparten.

Defaults: 15 msgs / 60 s por usuario, 100 / día UTC, 10 / conversación Chatwoot en la ventana.

Webhook: respuesta amable en el hilo. `POST /chat`: HTTP 429.

---

## Handoff humano

Si el usuario pide una persona, la API responde y asigna equipo en Chatwoot:

- **Soporte** — contratista / operación
- **Marketing** — venta / cliente guest

Panel interno: `https://chat.andes-workforce.com` (prod).

---

## Archivos clave

**API:** `src/chat/*`, `src/chatwoot/*`  
**CLIENT:** `src/components/chat/*`, `src/app/api/chat/`, `src/app/api/chatwoot/`

Presentación empresa: `ANDES-DOCS/PRESENTACION_ANDY_EMPRESA.md`.  
Fase 1 / roadmap: `ANDES-DOCS/informes/CONTEXTO_CHATWOOT_ANDI_FASE1_ROADMAP_FASE2.md`.  
Test server: `SERVIDOR_DESAROLLO/ANDI_CHATBOT_TEST_SERVER.md`.  
Prod kit: `PAQUETE_ANDY_PRODUCCION/`.

---

## Diagrama de secuencia (resumen)

1. Usuario abre Andes y el chat  
2. CLIENT → API `GET /chatwoot/identity` (JWT)  
3. API valida contrato y devuelve HMAC  
4. CLIENT `setUser` en Chatwoot  
5. Usuario escribe  
6. Chatwoot → API `POST /chatwoot/webhook` (`message_created`)  
7. API arma contexto + capas / LLM  
8. API `sendReply` con bot token  
9. El widget muestra la respuesta  

PNG: [../diagramas/flujo-mensaje-andy-chatwoot.png](../diagramas/flujo-mensaje-andy-chatwoot.png)
