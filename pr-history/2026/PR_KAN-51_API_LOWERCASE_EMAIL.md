# feat(auth): normalize email to lowercase on register

## Resumen

Se implementa la normalización del correo electrónico a minúsculas al momento del registro de un nuevo usuario. Esto garantiza consistencia en la base de datos y evita duplicados por diferencias de capitalizáción.

## Tipo de cambio

- [x] Nueva funcionalidad

## Issue relacionada

`KAN-51`

## Descripción detallada

### Problema

El correo electrónico se guardaba en la BD tal cual lo ingresaba el usuario, lo que podía generar duplicados si se registraba con distinta capitalización.

### Solución

En `auth.service.ts`, método `register()`, se aplica `.toLowerCase().trim()` al correo antes de:
1. Verificar si ya existe en la BD.
2. Persistir el usuario.

```ts
const { contrasena } = registerDto;
const correo = registerDto.correo.toLowerCase().trim();
```

El campo `correo` normalizado sobreescribe el valor del spread `...registerDto` al crear el usuario.

### Contexto adicional

El método `login()` ya contaba con `mode: 'insensitive'` en la query de Prisma, por lo que el login ya era case-insensitive. Este PR cierra la brecha en el lado del registro.

## Cómo probar / QA

1. Registrar usuario con correo con mayúsculas: `TestUser@EJEMPLO.com`.
2. Verificar en BD que se guardó como `testuser@ejemplo.com`.
3. Intentar registrar con `testuser@ejemplo.com` → error `400: El correo ya está registrado`.
4. Login con `TestUser@EJEMPLO.com` → debe funcionar correctamente.

## Checklist

- [x] Concurrency y edge cases revisados.
- [x] El build y linter pasan localmente.

## Notas para el reviewer

- Cambio mínimo (3 líneas modificadas en un único archivo).
- No afecta usuarios existentes ya registrados.
- Recomendado: correr migración de datos en prod para normalizar correos existentes con mayúsculas.

---

**Repositorio:** `API-ANDES`  
**Ticket:** `KAN-51`
