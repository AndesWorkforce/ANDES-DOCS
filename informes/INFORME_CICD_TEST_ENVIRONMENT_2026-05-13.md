# Informe: Configuración CI/CD — Entorno de Test
**Fecha:** 2026-05-13  
**Autor:** David Morcillo  
**Repositorios afectados:** `API-ANDES`, `CLIENT-ANDES`  
**Rama:** `test-development`

---

## Resumen

Se configuró el pipeline de despliegue automático (CI/CD) para el entorno de test en ambos repositorios. A partir de ahora, cualquier push a la rama `test-development` dispara automáticamente el deploy al servidor de test.

---

## Servidor de Test

| Campo | Valor |
|---|---|
| IP | `2.24.196.222` |
| Usuario SSH | `sysadmin` |
| Hostname | `srv1585097` |

---

## Problemas encontrados y soluciones

### 1. IP incorrecta en el workflow
El workflow de `API-ANDES` apuntaba a `147.93.44.202` (servidor de producción) en lugar del servidor de test `2.24.196.222`.  
**Solución:** Se actualizó el campo `host` en `.github/workflows/deploy-test.yml`.

### 2. Clave SSH no configurada
El secret `SSH_PRIVATE_KEY_TEST` no existía en ninguno de los dos repositorios, lo que causaba el error:
```
ssh: unable to authenticate, attempted methods [none publickey]
```
**Solución:** Se generó un par de claves ED25519 dedicado para GitHub Actions:
```bash
ssh-keygen -t ed25519 -C "github-actions-test" -f ~/.ssh/github_actions_test -N ""
```
- La clave **pública** se agregó a `/home/sysadmin/.ssh/authorized_keys` en el servidor de test.
- La clave **privada** se cargó como secret `SSH_PRIVATE_KEY_TEST` en ambos repositorios de GitHub.

### 3. Script de deploy faltante
No existía el script `/home/sysadmin/deploy_api_test.sh` ni `/home/sysadmin/deploy_client_test.sh` en el servidor de test.  
**Solución:** Se crearon ambos scripts manualmente.

### 4. NVM no disponible en sesiones SSH no interactivas
PM2 y pnpm están instalados bajo NVM (`~/.nvm/versions/node/v20.20.2/`), pero no se cargan automáticamente en sesiones SSH no interactivas (como las de GitHub Actions).  
**Solución:** Se agregó al inicio de cada script:
```bash
export NVM_DIR="/home/sysadmin/.nvm"
source $NVM_DIR/nvm.sh
```

### 5. pnpm abortaba en entorno CI
pnpm pedía confirmación interactiva para eliminar `node_modules`, lo que no es posible en CI:
```
ERR_PNPM_ABORTED_REMOVE_MODULES_DIR_NO_TTY
```
**Solución:** Se agregó `export CI=true` al script de deploy.

---

## Scripts de deploy en el servidor

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

## Workflows de GitHub Actions

Ambos repositorios tienen el archivo `.github/workflows/deploy-test.yml` configurado de la siguiente manera:

```yaml
on:
  push:
    branches:
      - test-development

steps:
  - uses: appleboy/ssh-action@v1.0.3
    with:
      host: 2.24.196.222
      username: sysadmin
      key: ${{ secrets.SSH_PRIVATE_KEY_TEST }}
      port: ${{ secrets.PORT }}
      script: /home/sysadmin/deploy_[api|client]_test.sh
```

---

## Secrets requeridos en GitHub

Los siguientes secrets deben estar configurados en **ambos** repositorios (`API-ANDES` y `CLIENT-ANDES`):

| Secret | Descripción |
|---|---|
| `SSH_PRIVATE_KEY_TEST` | Clave privada ED25519 para autenticación SSH en el servidor de test |
| `PORT` | Puerto SSH del servidor (por defecto `22`) |

---

## Procesos PM2 en el servidor de test

| Proceso | ID | Repositorio |
|---|---|---|
| `api-andes` | 4 | API-ANDES |
| `andes-client` | 5 | CLIENT-ANDES |

---

## Flujo completo de deploy

```
Push a test-development
        ↓
GitHub Actions dispara el workflow
        ↓
appleboy/ssh-action conecta por SSH a 2.24.196.222
        ↓
Ejecuta el script de deploy en el servidor
        ↓
git pull → pnpm install → build/migrate → pm2 restart
        ↓
Deploy completado
```
