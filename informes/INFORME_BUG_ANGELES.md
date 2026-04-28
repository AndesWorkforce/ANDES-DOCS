# Informe de Investigación — Bug acceso `/offers` de `angelesarita19@gmail.com`

**Fecha:** 03/03/2026  
**Repositorios afectados:** `API-ANDES`, `CLIENT-ANDES`  
**Rama de trabajo:** `hotfix/bug-angeles`  
**Estado:** Root cause identificado ✅ — Fix pendiente en DB ⏳

---

## 1. Descripción del problema reportado

La usuaria `angelesarita19@gmail.com` no podía acceder a la ruta `/offers` en producción. Al ingresar, el sistema le mostraba la pantalla de bloqueo **"Contrato en curso"** con un botón que redirigía a `/currentApplication`, impidiéndole ver las ofertas disponibles.

En el entorno de desarrollo el acceso a `/offers` funcionaba correctamente para la misma cuenta.

---

## 2. Flujo de acceso a `/offers`

```
Usuario navega a /offers
        ↓
OffersAccessGuard (CLIENT)
        ↓
checkUserContractStatus() — server action
        ↓
GET /api/users/current-contract (API)
        ↓
UsersService.getCurrentContract(userId)
        ↓
Si encuentra contrato activo (activo: true) → 200 OK
Si no encuentra → 404 NotFoundException
        ↓
checkUserContractStatus():
  - 200 → hasActiveContract: true  → bloquea acceso
  - 404 → hasActiveContract: false → permite acceso a /offers
```

---

## 3. Root cause identificado

### Problema 1 — Dato corrupto en DB

El contrato `0c5a5e1f` de Angeles tiene el campo `fechaInicioLabores` con el valor `20225-02-13` (año de 5 dígitos). Prisma lo devuelve como un objeto `Date` inválido, y al intentar llamar `.toISOString()` se lanza `Invalid time value` → HTTP 500.

### Problema 2 — Lógica del guard

El endpoint `GET /users/current-contract` no filtra por `estadoContratacion`, por lo que devuelve contratos en estado terminal (`CONTRATO_FINALIZADO`, `CANCELADO`, `EXPIRADO`) si tienen `activo: true`.

---

## 4. Fix requerido

### Fix inmediato — Corregir dato corrupto en DB de producción

```sql
UPDATE "ProcesoContratacion"
SET "fechaInicioLabores" = '2025-02-13'
WHERE id = '0c5a5e1f-cc7a-4b14-a335-aebf0ff6c75b';
```

### Fix de lógica — CLIENT-ANDES (`user-status.actions.ts`)

Tratar los estados terminales como `hasActiveContract: false`:

```typescript
const TERMINAL_STATES = ['CONTRATO_FINALIZADO', 'CANCELADO', 'EXPIRADO'];
const isTerminalState = TERMINAL_STATES.includes(response.data.estadoContratacion);
return {
  success: true,
  data: { hasActiveContract: !isTerminalState, contractDetails: { ... } }
};
```

---

## 5. Archivos modificados en `hotfix/bug-angeles`

| Repositorio | Archivo | Cambio |
|---|---|---|
| `API-ANDES` | `src/users/users.controller.ts` | Logger + log de userId |
| `API-ANDES` | `src/users/users.service.ts` | Log de contrato encontrado / warn si no existe |
| `CLIENT-ANDES` | `src/app/pages/offers/actions/user-status.actions.ts` | Logs de resultado + hasActiveContract |

---

## 6. Acciones pendientes

- [ ] Ejecutar el UPDATE en la DB de producción
- [ ] Aplicar el fix de lógica en `user-status.actions.ts`
- [ ] Verificar que Angeles pueda acceder a `/offers` tras el fix
- [ ] Evaluar si hay otros usuarios con `activo: true` + estado terminal en la DB
