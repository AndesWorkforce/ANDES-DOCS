# chore(users): add contract access logs for bug-angeles investigation

## Resumen

Agrega logs de diagnóstico en el flujo de acceso a contrato actual (`GET /users/current-contract`) para facilitar la investigación del bug que bloqueaba a la cuenta `angelesarita19@gmail.com` al intentar acceder a `/offers`.

## Tipo de cambio

- [x] Bugfix
- [x] Chore

## Descripción detallada

**`users.controller.ts`:**
- Log del `userId` del token al entrar a `GET /users/current-contract`.

**`users.service.ts` → `getCurrentContract()`:**
- Si **no** se encuentra contrato activo: `logger.warn` con `userId`.
- Si **sí** se encuentra: `logger.log` con `userId`, `contratoId`, `estadoContratacion` y `activo`.

Este PR **no cambia ninguna lógica de negocio**, solo agrega observabilidad.

## Cómo probar / QA

1. Iniciar la API (`pnpm run start:dev`).
2. Autenticarse con usuario que tenga `ProcesoContratacion` con `activo: true`.
3. `GET /users/current-contract` → verificar líneas `[current-contract]` y `[getCurrentContract]` en los logs.
4. Repetir con usuario sin contratos activos → verificar el `warn` de no encontrado.

## Checklist

- [x] No se modifica lógica de negocio, solo se añaden logs.
- [x] El build y linter pasan localmente.

## Notas para el reviewer

- Safe para merge a `master` sin riesgo de regresiones.
- Follow-up: una vez confirmado el root cause, evaluar fix para limpiar contratos con `activo: true` en estado terminal.

---

**Repositorio:** `API-ANDES`  
**Rama:** `hotfix/bug-angeles`
