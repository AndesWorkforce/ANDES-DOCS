# CLIENT-ANDES — responsabilidad frontend

**Repo:** `CLIENT-ANDES`  
**Stack:** Next.js 16 (App Router), React 19, TypeScript, Tailwind 4, Zustand, Axios, pnpm  
**Qué es:** la aplicación que ve el usuario. Pinta el producto Andes y habla con la API. No es dueña de contratos ni de las respuestas de Andy.

---

## Dueño de

- Sitio público: home, about, services, contact, team, blog, ofertas, FAQ, privacy.
- Auth en el navegador: login/registro, cookie `auth_token`, selector de rol.
- Áreas autenticadas: perfil, postulaciones, cuenta, guía del contratista, bonificaciones, e-sign público.
- Dashboards: empresas (`/companies/...`), admin (`/admin/...`), Admin Hub (`/admin-hub`, sin Andy).
- Widget de Andy: `ChatProvider` global en `src/app/layout.tsx`.
- BFF Next (server routes) que reenvían JWT a la API:
  - `src/app/api/chat/route.ts` → `POST {API}/chat`
  - `src/app/api/chatwoot/identity/route.ts`
  - `src/app/api/chatwoot/guest-identity/route.ts`
  - `src/app/api/chatwoot/conversations/route.ts`
  - `src/app/api/chatwoot/new-conversation/route.ts`
- Algunos envíos de correo desde el propio Next (Resend / Office 365) — no confundir con `EmailModule` de la API.

---

## No es dueño de

- Validar contrato activo en servidor (eso es API `getCurrentContract`).
- Generar el texto de Andy (`ChatService`).
- Guardar conversaciones (Chatwoot) ni el perfil canónico (Postgres Andes).
- TLS, DNS, contenedores.

El hook `useChatAccess` **pregunta** a la API si hay contrato activo; no inventa el acceso.

---

## Andy en el client

Archivos clave: `src/components/chat/`.

| Pieza | Rol |
|---|---|
| `ChatProvider` | Decide widget vs formulario guest vs nada |
| `useChatAccess` | `isAuthenticated` + contrato activo |
| `ChatwootWidget` | SDK Chatwoot, identidad HMAC, nuevo tema |
| `ChatWidget` + `useChat` | Fallback BFF para contratista |
| `GuestChatForm` | Email + kind `client` \| `candidate` |
| `chatwoot-sdk.ts` | `setUser`, `reset`, hash de identidad |

Reglas:

1. `/admin-hub` → no se renderiza chat.
2. Contratista con acceso + Chatwoot OK → `ChatwootWidget`.
3. Contratista + Chatwoot caído → `ChatWidget` (`POST /api/chat`).
4. Visitante sin formulario → `GuestChatForm`.
5. Visitante con datos + Chatwoot OK → widget con `guest:{kind}:{email}`.
6. Visitante sin Chatwoot → vuelve al formulario (no hay fallback BFF guest).

`NEXT_PUBLIC_CHATWOOT_*` se **compilan** en el build. Cambiar el token o la URL exige rebuild, no solo restart.

---

## Cómo habla con la API

| Camino | Uso |
|---|---|
| Axios browser (`NEXT_PUBLIC_API_URL`) | CRUD general autenticado |
| Server actions / `INTERNAL_API_URL` | Llamadas server-side (preferible en Docker) |
| BFF `/api/chat*` | Chat: cookie → Bearer hacia Nest |

En test, Nginx manda `/api/chat` y `/api/chatwoot/(identity|conversations)` al proceso Next (3000), no al Nest (3001).

---

## Deploy

| Entorno | Trigger | Qué corre |
|---|---|---|
| Test | push `test-development` | `.github/workflows/deploy-test.yml` → `deploy_client_test.sh` |
| Prod | push `master` | `.github/workflows/deploy.yml` → `./deploy_client.sh` |
