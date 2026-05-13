# Configuración CI/CD — Entorno de Test

**Fecha:** 13/05/2026  
**Autor:** David Morcillo  
**Repositorios:** `API-ANDES`, `CLIENT-ANDES`  
**Estado:** Completado ✅

---

## 1. Objetivo

Configurar un pipeline de despliegue automático (CI/CD) para el entorno de test, de modo que cualquier push a la rama `test-development` en ambos repositorios dispare automáticamente el deploy al servidor de test.

---

## 2. Servidor de Test

| Campo | Valor |
|---|---|
| IP pública | `2.24.196.222` |
| Usuario SSH | `sysadmin` |
| Hostname | `srv1585097` |
| Node.js | `v20.20.2` (via NVM) |
| Gestor de paquetes | `pnpm` |
| Process manager | `pm2` |

---

## 3. Arquitectura del pipeline

```
Push a rama test-development
        ↓
GitHub Actions dispara el workflow
        ↓
appleboy/ssh-action@v1.0.3
conecta por SSH a 2.24.196.222
        ↓
Ejecuta script de deploy en el servidor
        ↓
git pull → pnpm install → build/migrate → pm2 restart
        ↓
Deploy completado ✅
```

---

## 4. Workflows de GitHub Actions

Ambos repositorios tienen el archivo `.github/workflows/deploy-test.yml`:

**API-ANDES**
```yaml
name: Deploy API — test-development

on:
  push:
    branches:
      - test-development

jobs:
  deploy:
    name: Deploy to server (test)
    runs-on: ubuntu-latest
    steps:
      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: 2.24.196.222
          username: sysadmin
          key: ${{ secrets.SSH_PRIVATE_KEY_TEST }}
          port: ${{ secrets.PORT }}
          script: /home/sysadmin/deploy_api_test.sh
```

**CLIENT-ANDES**
```yaml
name: Deploy Client — test-development

on:
  push:
    branches:
      - test-development

jobs:
  deploy:
    name: Deploy to server (test)
    runs-on: ubuntu-latest
    steps:
      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: 2.24.196.222
          username: sysadmin
          key: ${{ secrets.SSH_PRIVATE_KEY_TEST }}
          port: ${{ secrets.PORT }}
          script: /home/sysadmin/deploy_client_test.sh
```

---

## 5. Scripts de deploy en el servidor

### `/home/sysadmin/deploy_api_test.sh`
```bash
#!/bin/bash
set -e
export NVM_DIR="/home/sysadmin/.nvm"
source $NVM_DIR/nvm.sh
export CI=true
cd /var/www/cliente-principal/API-ANDES
git pull origin test-development
pnpm install --frozen-lockfile
pnpm run db:migrate
pnpm run build
pm2 restart api-andes
echo "API test deployed OK"
```

### `/home/sysadmin/deploy_client_test.sh`
```bash
#!/bin/bash
set -e
export NVM_DIR="/home/sysadmin/.nvm"
source $NVM_DIR/nvm.sh
export CI=true
cd /var/www/cliente-principal/CLIENT-ANDES
git pull origin test-development
pnpm install --frozen-lockfile
pnpm run build
pm2 restart andes-client
echo "Client test deployed OK"
```

---

## 6. Secrets de GitHub requeridos

Deben estar configurados en **ambos** repositorios en GitHub → Settings → Secrets and variables → Actions:

| Secret | Descripción |
|---|---|
| `SSH_PRIVATE_KEY_TEST` | Clave privada ED25519 para autenticación SSH en el servidor de test |
| `PORT` | Puerto SSH del servidor (`22`) |

> **Nota de seguridad:** La clave SSH generada es exclusiva para GitHub Actions. La clave pública correspondiente está registrada en `/home/sysadmin/.ssh/authorized_keys` del servidor de test.

---

## 7. Procesos PM2 en el servidor de test

| Proceso PM2 | ID | Repositorio | Puerto |
|---|---|---|---|
| `api-andes` | 4 | API-ANDES | API REST |
| `andes-client` | 5 | CLIENT-ANDES | Frontend Next.js |

---

## 8. Problemas encontrados durante la configuración

| # | Problema | Error | Solución |
|---|---|---|---|
| 1 | IP incorrecta en el workflow | `i/o timeout` al conectar a `147.93.44.202` | Se actualizó la IP a `2.24.196.222` |
| 2 | Secret `SSH_PRIVATE_KEY_TEST` no existía | `unable to authenticate, no supported methods remain` | Se generó par de claves ED25519 y se configuró el secret en GitHub |
| 3 | Script de deploy no existía en el servidor | `No such file or directory` | Se crearon los scripts manualmente en el servidor |
| 4 | Ruta del repositorio incorrecta en el script | `cd: No such file or directory` | Se corrigió a `/var/www/cliente-principal/` |
| 5 | NVM no disponible en sesión SSH no interactiva | `pm2: command not found` | Se agregó `source $NVM_DIR/nvm.sh` al inicio del script |
| 6 | pnpm requería confirmación interactiva en CI | `ERR_PNPM_ABORTED_REMOVE_MODULES_DIR_NO_TTY` | Se agregó `export CI=true` al script |

---

## 9. Cómo regenerar la clave SSH (en caso de rotación)

```bash
# 1. Generar nueva clave en local (Windows PowerShell)
ssh-keygen -t ed25519 -C "github-actions-test" -f "$env:USERPROFILE\.ssh\github_actions_test" -N '""'

# 2. Agregar la clave pública al servidor de test
echo "CONTENIDO_CLAVE_PUBLICA" >> /home/sysadmin/.ssh/authorized_keys

# 3. Actualizar el secret SSH_PRIVATE_KEY_TEST en ambos repositorios de GitHub
# GitHub → Repo → Settings → Secrets → SSH_PRIVATE_KEY_TEST
```

---

## 10. Referencias

- Workflow API: `.github/workflows/deploy-test.yml` en `AndesWorkforce/API-ANDES`
- Workflow Client: `.github/workflows/deploy-test.yml` en `AndesWorkforce/CLIENT-ANDES`
- Action utilizada: [appleboy/ssh-action@v1.0.3](https://github.com/appleboy/ssh-action)
