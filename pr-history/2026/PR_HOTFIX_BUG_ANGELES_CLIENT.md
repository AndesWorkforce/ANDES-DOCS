# chore(offers): add contract access logs for bug-angeles investigation

## Resumen

Agrega logs de diagnóstico en la server action `checkUserContractStatus()` para rastrear si el usuario pasa o no el guard de acceso a `/offers`, como parte de la investigación del bug que bloqueaba a `angelesarita19@gmail.com`.

## Tipo de cambio

- [x] Bugfix
- [x] Chore

## Descripción detallada

**`user-status.actions.ts`** — logs en `checkUserContractStatus()`:

**Caso 200 (contrato encontrado):**
```
[checkUserContractStatus] Contrato recibido | id=... | estadoContratacion=CONTRATO_FINALIZADO | activo=true | hasActiveContract=true
```

**Caso 404 (sin contrato activo):**
```
[checkUserContractStatus] 404 recibido de /users/current-contract → hasActiveContract=false
```

Este PR **no cambia ninguna lógica de negocio**, solo agrega observabilidad en el servidor Next.js.

## Cómo probar / QA

1. Autenticarse con usuario que tenga contrato activo.
2. Navegar a `/offers`.
3. Revisar los logs del servidor Next.js → debe aparecer `[checkUserContractStatus] Contrato recibido`.
4. Repetir con usuario sin contratos → debe aparecer `404 recibido → hasActiveContract=false`.

## Checklist

- [x] No se modifica lógica de negocio.
- [x] El log no expone datos sensibles del usuario.
- [x] El build y linter pasan localmente.

## Notas para el reviewer

- Rama asociada en API-ANDES: `hotfix/bug-angeles`.
- Follow-up: fix definitivo en `user-status.actions.ts` para tratar estados terminales como `hasActiveContract: false`.

---

**Repositorio:** `CLIENT-ANDES`  
**Rama:** `hotfix/bug-angeles`
