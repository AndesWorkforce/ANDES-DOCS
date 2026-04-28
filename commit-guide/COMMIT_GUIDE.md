# Guía de Commits — Andes Workforce

Esta guía define el formato estándar para los mensajes de commit en todos los repositorios de Andes Workforce.  
El equipo usa un hook de Git (`commit-msg`) que valida automáticamente cada commit antes de aceptarlo.

---

## Estructura del mensaje

```
<Asunto>
<línea en blanco>
What: <qué cambió>
Why: <por qué fue necesario>
<otras líneas de contexto si aplica>

<TICKET>
```

### Reglas

| Campo | Regla |
|---|---|
| **Asunto** | 20–50 caracteres, primera letra en mayúscula |
| **Asunto** | Sin prefijos de Conventional Commits (`feat:`, `fix:`, `chore:`, etc.) |
| **Separador** | Línea 2 debe estar en blanco |
| **Cuerpo** | Mínimo 3 líneas de contenido (sin contar el ticket) |
| **`What:`** | Obligatorio y no vacío |
| **`Why:`** | Obligatorio y no vacío |
| **Líneas del cuerpo** | Cada línea entre 20 y 50 caracteres |
| **Ticket** | Última línea no vacía: `RM-123`, `SDT-456` o `KAN-789` |
| **Duplicados** | No se permiten líneas duplicadas en el cuerpo |

---

## Ejemplo válido

```
Add email lowercase normalization

What: Emails now saved in lowercase
Why: Prevent duplicate accounts on register
Applies on register endpoint only

KAN-51
```

---

## Ejemplos inválidos

```
# ❌ Asunto demasiado corto (< 20 caracteres)
fix email bug

KAN-51
```

```
# ❌ Usa prefijo de Conventional Commits
feat: add holidays module

What: New holidays CRUD module added
Why: Required for KAN-40 calendar feature
Available for all LATAM countries

KAN-40
```

```
# ❌ Falta el What: / Why:
Add holidays module to the backend

Implemented CRUD endpoints for holidays
Supports pagination and country filter
Used in bonifications page by users

KAN-40
```

```
# ❌ Ticket inválido (prefijo no permitido)
Add holidays module to the backend

What: New holidays CRUD module added
Why: Required for KAN-40 calendar feature
Available for all LATAM countries

JIRA-40
```

---

## Prefijos de tickets permitidos

| Prefijo | Uso |
|---|---|
| `KAN` | Tickets de requerimientos de producto |
| `SDT` | Infraestructura, DevOps, mejoras del equipo |
| `RM` | Tareas de marketing |

---

## Hook automático

El hook `commit-msg` está instalado con Husky en `API-ANDES` y `CLIENT-ANDES`.  
Si el mensaje no cumple las reglas, el commit es rechazado con un mensaje de error que indica exactamente qué falló.

Para omitir el hook en casos excepcionales (no recomendado):

```bash
git commit --no-verify -m "mensaje"
```

---

## Herramientas recomendadas

- **VS Code extension**: [Conventional Commits](https://marketplace.visualstudio.com/items?itemName=vivaxy.vscode-conventional-commits) — puede usarse adaptando los campos al formato propio del equipo.
- El script de validación completo está en `scripts/validate-commit-msg.mjs` dentro de cada repositorio.
