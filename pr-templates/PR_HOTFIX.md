# [HOTFIX] Título del fix

## Resumen

Descripción concisa del problema que se corrige y el impacto que tenía en producción.

## Ticket relacionado

`KAN-XXX` / `SDT-XXX`

## Tipo de cambio

- [x] Bugfix

## Descripción del problema

### Comportamiento incorrecto

Describe qué fallaba: qué veía el usuario, qué respuesta devolvía la API, etc.

### Root cause

Explica la causa raíz del problema (no solo el síntoma).

## Solución implementada

Describe exactamente qué se cambió y por qué eso resuelve el problema.

### Archivos modificados

| Archivo | Cambio |
|---|---|
| `src/...` | Descripción del fix |

## Cómo probar / QA

1. Reproducir el bug antes del fix (pasos):
   1. ...
2. Aplicar el fix y verificar que ya no ocurre:
   1. ...
3. Verificar que no hay regresiones en flujos relacionados.

## Checklist

- [ ] Los commits siguen la [guía de commits](../../commit-guide/COMMIT_GUIDE.md) del equipo.
- [ ] Fix mínimo: no modifica lógica más allá de lo necesario.
- [ ] Build y linter pasan localmente.
- [ ] Sin cambios de comportamiento en flujos no relacionados.

## Notas para el reviewer

- Este PR **sí / no** cambia lógica de negocio.
- Safe para merge a `master` / requiere validación adicional.
- Follow-up pendiente (si aplica): ...
