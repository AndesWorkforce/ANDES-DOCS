# Conectar pgAdmin4 a PostgreSQL de Producción

## 1. Abrir el túnel SSH

Ejecutá el script PowerShell (desde el directorio `ANDES-DOCS/scripts`):

```powershell
.\tunnel-postgres-prod.ps1
```

**Dejá la ventana abierta** mientras trabajás con pgAdmin4. El túnel estará activo y verás el mensaje:

```
Creando túnel SSH...
Presiona Ctrl+C para cerrar el túnel
```

## 2. Configurar pgAdmin4

1. **Abrí pgAdmin4**
2. **Clic derecho en "Servers"** → **Create** → **Server**
3. **Pestaña "General":**
   - **Name:** `Andes Workforce PROD (SSH Tunnel)`

4. **Pestaña "Connection":**
   - **Host:** `localhost`
   - **Port:** `5433` ⚠️ (puerto local del túnel, NO el 5432)
   - **Maintenance database:** `andes_prod`
   - **Username:** `andesworkforce`
   - **Password:** (pedísela al equipo, fue rotada post-incidente del 11 ago 2026)
   - ✅ **Save password:** (opcional, para no escribirla cada vez)

5. **Pestaña "Advanced":**
   - **DB restriction:** `andes_prod` (opcional, para mostrar solo esta DB)

6. **Clic en "Save"**

## 3. Ejecutar las consultas

Una vez conectado, expandí:

```
Servers
  └── Andes Workforce PROD (SSH Tunnel)
      └── Databases
          └── andes_prod
              └── Schemas
                  └── public
                      └── Tables
                          └── Usuario
```

Clic derecho en `andes_prod` → **Query Tool** y pegá la consulta del archivo:

```
ANDES-DOCS\queries\buscar_videos_contratistas_prioridad_alta.sql
```

## 4. Exportar resultados

Si querés exportar los resultados a CSV/Excel:

1. Ejecutá la consulta (botón ▶ o F5)
2. En la grilla de resultados, clic en el **icono de descarga** ⬇️
3. Seleccioná **CSV** o **Excel**
4. Guardá como `videos_contratistas_prioridad_alta_YYYYMMDD.csv`

## 5. Cerrar el túnel

Cuando termines:

1. **Desconectate de pgAdmin4**: clic derecho en el servidor → **Disconnect**
2. **Cerrá el túnel SSH**: andá a la PowerShell donde corre el script y presioná **Ctrl+C**

Verás el mensaje: `✓ Túnel cerrado correctamente`

---

## ⚠️ Consideraciones de seguridad

### Según el informe INCIDENTE_SEGURIDAD_2026-08-11.md:

- La contraseña original de PostgreSQL **fue comprometida** el 11 agosto 2026
- El plan de remediación indica **rotar contraseñas** (sección 9.2, ítem 4)
- Solo ejecutá consultas de **LECTURA** (`SELECT`)
- **NO** ejecutes `UPDATE`, `DELETE`, `INSERT` desde pgAdmin en producción

### Si la contraseña no fue rotada todavía:

**STOP ✋** — No te conectes hasta que el equipo de infra rote la contraseña. El atacante aún tiene acceso conocido.

---

## Alternativa: Túnel manual

Si preferís crear el túnel manualmente en una PowerShell separada:

```powershell
ssh -N -L 5433:localhost:5432 server-andes
```

Luego conectá pgAdmin4 como se indica arriba.
