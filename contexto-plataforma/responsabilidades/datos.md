# Datos — responsabilidad de persistencia

Cuatro almacenes distintos. No compartir credenciales ni volúmenes entre Andes y Chatwoot.

---

## 1. PostgreSQL Andes

**Dueño:** API (Prisma).  
**Quién escribe:** solo `api_prod` / proceso Nest de test.  
**Qué guarda:** usuarios, empresas, ofertas, postulaciones, contratos, nómina/Admin Hub, feriados, plantillas, auditoría.

| Entorno | Dónde |
|---|---|
| Local | instancia local, `DATABASE_URL` del `.env` |
| Test | Postgres en el host test, DB típica `andes_prod` o la de test del `.env` |
| Prod | contenedor `db_prod` (`postgres:15-alpine` en compose 2026), red `internal`, volumen `db_data` |

Adminer prod: `https://db.andes-workforce.com` con BasicAuth. No es un backoffice de producto.

Migraciones: `pnpm db:migrate` desde API-ANDES. Guía expand/contract: `ANALISIS_ANDES_PROD/CHECKLIST_MIGRACIONES_EXPAND_CONTRACT.md`.

---

## 2. Redis Andes

**Dueño:** API (BullMQ / cache).  
**Prod:** `redis_prod`, AOF, password, maxmemory 256 MB, red `internal`.  
**Test/local:** Redis en el host, bind localhost.

No usar este Redis para Chatwoot.

Limitación Andy: el rate limit de chat **no** está en Redis; vive en memoria del proceso Nest.

---

## 3. AWS S3

**Dueño:** `FilesModule` + limpieza `S3CleanupModule`.  
**Qué:** CVs, documentos de contrato, evidencias, media de perfil, exports.

CLIENT a veces arma URLs con `NEXT_PUBLIC_API_URL`; la autorización de objetos es de la API.

Incidencias: `ANDES-DOCS/informes/RECONEXION_S3_POST_INCIDENTE.md`.

---

## 4. PostgreSQL + Redis de Chatwoot

**Dueño:** el compose de Chatwoot.  
**Qué:** contactos, conversaciones, cuentas de agentes.  
**No** contiene contratos Andes. El nexo es `andes_user_id` / email en atributos del contacto.

Si se borra este volumen se pierde el historial del widget; Andes (nómina, login) sigue intacto.

---

## Backups

| Qué | Cómo (prod, documentado) |
|---|---|
| Postgres Andes | `docker exec db_prod pg_dump ...` y/o `backup_andes.sh` de `backupuser` |
| Redis Andes | volumen `redis_data` + AOF — no es backup de negocio |
| S3 | versionado / políticas AWS (fuera de este repo) |
| Chatwoot | volúmenes del compose `~/app/chatwoot` |

En el inventario de abril 2026 **no había crontab de dump**. Verificar en el servidor antes de asumir que hay backup diario.

Nunca: `docker compose down -v` en producción.
