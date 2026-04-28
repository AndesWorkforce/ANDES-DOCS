# Informe de Incidente de Seguridad - Servidor de Producción

**Fecha del incidente:** 20 de abril de 2026  
**Fecha de detección:** 20 de abril de 2026 (~14:01 UTC)  
**Fecha de resolución:** 20 de abril de 2026 (~19:30 UTC)  
**Severidad:** CRÍTICA  
**Estado:** Resuelto (pendiente rotación de credenciales)

---

## Resumen Ejecutivo

El servidor de producción `andesworkforce.com` sufrió una caída visible del frontend (Next.js) que derivó en la detección de un **compromiso de seguridad activo**. Se encontró un backdoor instalado como servicio systemd (`defunct.service`) utilizando la herramienta `gsocket` (gs-netcat), que otorgó al atacante **acceso root interactivo remoto durante aproximadamente 40 días** (desde el 12 de marzo de 2026 hasta el 20 de abril de 2026).

---

## Línea de Tiempo

| Fecha | Evento |
|-------|--------|
| 2025-12-09 | El atacante descargó el binario inicial desde `149.248.44.88` mediante `wget`. |
| 2025-12-09 | Se añadió `@reboot root /etc/profile.d/d.sh` a `/etc/crontab`. |
| 2026-03-12 | El servicio `defunct.service` se activó. Desde este momento el atacante tuvo shell root interactiva. |
| 2026-04-20 ~14:01 UTC | Caída visible del frontend detectada en Grafana (spike de latencia 0s → ~13s). |
| 2026-04-20 ~19:30 UTC | Backdoor identificado, detenido y eliminado. Persistencia removida. |

---

## Root Cause

### Vector de entrada

No determinado con certeza. Las evidencias apuntan a:
- Credencial SSH comprometida, o
- Exploit de privilege escalation desde sesión con permisos bajos.

### Mecanismo de persistencia (triple)

1. **`/etc/profile.d/d.sh`** — Script ejecutado al iniciar sesión cualquier usuario.
2. **`/etc/crontab` con `@reboot`** — Ejecutaba `d.sh` como root en cada reinicio.
3. **`defunct.service`** — Servicio systemd en `/usr/lib/systemd/system/defunct.service`, habilitado.

### El backdoor: gsocket / gs-netcat

El binario `/usr/bin/defunct` era **gsocket** (`gs-netcat`), una herramienta de tunneling cifrado:
- `-k defunct.dat` → clave de autenticación
- `-i` → shell interactiva
- `-l` → modo escucha
- El proceso se disfrazaba como `[slub_flushwq]` (nombre de kernel thread legítimo)

gsocket enruta las conexiones a través de una **red relay global cifrada** — el atacante podía conectarse desde cualquier IP sin conexión directa visible.

---

## Impacto

Con acceso root activo durante **40 días**, el atacante tuvo acceso potencial a:
- Archivos `.env` con todas las credenciales (JWT secret, DB password, AWS keys, API keys)
- Base de datos `andes_prod` completa
- Logs de aplicación
- Claves SSH

> **No es posible determinar con certeza si hubo exfiltración de datos.**

---

## Remediación Ejecutada

| Acción | Estado |
|--------|--------|
| `defunct.service` detenido y deshabilitado | ✅ Completado |
| `/usr/bin/defunct` eliminado | ✅ Completado |
| `/lib/systemd/system/defunct.dat` eliminado | ✅ Completado |
| `/etc/profile.d/d.sh` eliminado | ✅ Completado |
| Entrada `@reboot` removida de `/etc/crontab` | ✅ Completado |
| `systemctl daemon-reload` ejecutado | ✅ Completado |
| Claves SSH auditadas | ✅ Sin entradas no autorizadas |

---

## Acciones Pendientes (OBLIGATORIAS)

| Prioridad | Acción | Responsable |
|-----------|--------|-------------|
| 🔴 Alta | Rotar `JWT_SECRET` y reiniciar backend | DevOps |
| 🔴 Alta | Cambiar contraseña de PostgreSQL y actualizar `.env` | DevOps |
| 🔴 Alta | Revocar y regenerar AWS S3 Access Key / Secret Key | DevOps |
| 🔴 Alta | Rotar cualquier otra API key en archivos `.env` | DevOps |
| 🔴 Alta | Cambiar contraseñas de usuarios `david` y `webuser` | SysAdmin |
| 🟡 Media | Investigar el vector de entrada inicial (logs SSH dic 2025) | SysAdmin |
| 🟡 Media | Implementar rate limiting en `/api/auth/login` | Backend Dev |
| 🟡 Media | Bloquear acceso a `/.git/` y rutas sensibles desde nginx | SysAdmin |
| 🟡 Media | Auditar si hubo exfiltración de datos de usuarios | DevOps / Legal |
| 🟢 Baja | Evaluar reinstalación limpia del SO | SysAdmin |
| 🟢 Baja | Implementar monitorización de integridad de archivos (AIDE/Wazuh) | SysAdmin |
| 🟢 Baja | Habilitar 2FA para acceso SSH | SysAdmin |

---

## Indicadores de Compromiso (IoC)

| Tipo | Valor |
|------|-------|
| IP atacante | `149.248.44.88` (Vultr) |
| Herramienta | `gsocket` / `gs-netcat` |
| Binario malicioso | `/usr/bin/defunct` |
| Nombre de disfraz del proceso | `[slub_flushwq]` |
| Servicio systemd malicioso | `defunct.service` |
| Archivo de persistencia 1 | `/etc/profile.d/d.sh` |
| Archivo de persistencia 2 | `/etc/crontab` entrada `@reboot` |

---

## Lecciones Aprendidas

1. La monitorización detectó la caída del frontend pero no el compromiso de seguridad.
2. El nombre `defunct.service` imitó `dbus.service` para pasar desapercibido.
3. El proceso se disfrazó como kernel thread `[slub_flushwq]` para evadir `ps aux`.
4. `gsocket` no genera conexiones entrantes visibles en `netstat`/`ss`.
5. El `@reboot` en `/etc/crontab` habría reactivado el backdoor si el servidor se hubiera reiniciado antes de la limpieza.

---

## Referencias

- [gsocket / gs-netcat](https://github.com/hackerschoice/gsocket)
- [MITRE ATT&CK T1543.002](https://attack.mitre.org/techniques/T1543/002/) — Systemd Service
- [MITRE ATT&CK T1053.003](https://attack.mitre.org/techniques/T1053/003/) — Cron
- [MITRE ATT&CK T1036.005](https://attack.mitre.org/techniques/T1036/005/) — Masquerading
