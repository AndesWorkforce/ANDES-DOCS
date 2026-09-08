# Contexto de la plataforma Andes Workforce

**Carpeta canónica** para entender el entorno: qué hace cada pieza, dónde corre y cómo encaja Andy.

**Última actualización:** 8 de septiembre de 2026  
**FigJam de arquitectura:** [tablero Andy CLIENT + API](https://www.figma.com/board/U5q4W4fLN7rianGb83y3yM)

Esta carpeta **no reemplaza** análisis históricos ni runbooks largos. Los resume y apunta a la fuente. Si hay conflicto con un documento viejo, prevalece lo que está aquí.

---

## Cómo leer esto

| Si necesitas… | Empieza por… |
|---|---|
| Ver quién hace qué | [mapa-responsabilidades.md](./mapa-responsabilidades.md) |
| IPs, dominios, puertos y ramas | [entornos.md](./entornos.md) |
| El dibujo de Andy + CLIENT + API | [diagramas/](./diagramas/) |
| Detalle de una pieza | [responsabilidades/](./responsabilidades/) |

---

## Responsabilidades

| Documento | Dueño lógico | Qué cubre |
|---|---|---|
| [client.md](./responsabilidades/client.md) | CLIENT-ANDES | UI, auth en cookie, BFF de chat, Admin Hub, sitios públicos |
| [api.md](./responsabilidades/api.md) | API-ANDES | Negocio, JWT, Prisma, S3, Andy (cerebro), webhooks |
| [chatbot-andy.md](./responsabilidades/chatbot-andy.md) | Módulos `chat` + widget | Audiencias, capas de respuesta, fallback BFF |
| [chatwoot.md](./responsabilidades/chatwoot.md) | Chatwoot self-hosted | Inbox, agentes, handoff humano, panel interno |
| [servidor.md](./responsabilidades/servidor.md) | Infra del host | Test (Nginx + PM2) y prod (Docker + Traefik) |
| [datos.md](./responsabilidades/datos.md) | Persistencia | PostgreSQL Andes, Redis, S3, BD de Chatwoot |
| [operacion.md](./responsabilidades/operacion.md) | DevOps | CI/CD, monitoreo, kill switch, pendientes |

---

## Repos en este workspace

| Carpeta | Rol |
|---|---|
| `CLIENT-ANDES` | Frontend Next.js |
| `API-ANDES` | Backend NestJS |
| `CHATWOOT-LOCAL` | Compose local de Chatwoot |
| `CHATWOOT-PROD` | Referencia histórica de Chatwoot en prod |
| `PAQUETE_ANDY_PRODUCCION` | Kit canónico para montar Andy en prod |
| `SERVIDOR_DESAROLLO` | Inventarios y runbooks de servidor (histórico + operativo) |
| `ANALISIS_ANDES_PROD` | Blue-green, MFA, CI/CD de prod |
| `KUBERNETES` | Plan futuro — **no es el runtime actual** |

---

## Principio de separación

- **CLIENT** pinta y autentica en el navegador. No decide respuestas de Andy.
- **API** es la única fuente de verdad de contratos, perfil y texto de Andy.
- **Chatwoot** transporta la conversación y escala a humanos. No conoce Andes.
- **Nginx / Traefik** enrutan. No contienen lógica de negocio.
- **LLM** (Groq u OpenAI) solo entra si las capas estáticas no responden.

---

## Documentos que este paquete actualiza

| Tema | Antes (sigue existiendo) | Ahora |
|---|---|---|
| Servidor test | `SERVIDOR_DESAROLLO/CONTEXTO_SERVIDOR.md` (desactualizado: puertos invertidos y checklist pendiente) | [entornos.md](./entornos.md) + [servidor.md](./responsabilidades/servidor.md) |
| Servidor prod | `SERVIDOR_DESAROLLO/CONTEXTO_SERVIDOR_PRODUCCION.md` | [servidor.md](./responsabilidades/servidor.md) |
| Andy / Chatwoot | `API-ANDES/docs/ANDI_CHATBOT_SYSTEM.md`, `ANDES-DOCS/informes/CONTEXTO_CHATWOOT_ANDI_FASE1_ROADMAP_FASE2.md` | [chatbot-andy.md](./responsabilidades/chatbot-andy.md) + [chatwoot.md](./responsabilidades/chatwoot.md) |
| Diagramas | FigJam suelto + PNG en Descargas | [diagramas/](./diagramas/) |
