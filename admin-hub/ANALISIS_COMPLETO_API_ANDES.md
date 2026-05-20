# 📊 ANÁLISIS COMPLETO DEL PROYECTO API-ANDES

**Fecha del Análisis:** 22 de Enero de 2026  
**Versión del Proyecto:** 0.0.1  
**Analista:** Sistema de Análisis Automatizado

---

## 📋 TABLA DE CONTENIDOS

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Stack Tecnológico](#stack-tecnológico)
3. [Arquitectura del Sistema](#arquitectura-del-sistema)
4. [Estructura del Proyecto](#estructura-del-proyecto)
5. [Módulos Funcionales](#módulos-funcionales)
6. [Modelo de Datos](#modelo-de-datos)
7. [Seguridad y Autenticación](#seguridad-y-autenticación)
8. [Integraciones Externas](#integraciones-externas)
9. [Análisis de Dependencias](#análisis-de-dependencias)
10. [Sistema de Migraciones](#sistema-de-migraciones)
11. [Documentación Técnica](#documentación-técnica)
12. [CI/CD y Deployment](#cicd-y-deployment)
13. [Recomendaciones y Observaciones](#recomendaciones-y-observaciones)

---

## 1. RESUMEN EJECUTIVO

### 1.1 Descripción General

**ANDES API** es un sistema backend empresarial robusto desarrollado con **NestJS 11** que actúa como plataforma de gestión de recursos humanos. Conecta candidatos con empresas a través de un proceso de postulación gestionado por administradores, ofreciendo:

- ✅ Gestión completa del ciclo de vida de postulaciones
- ✅ Sistema de autenticación multinivel (JWT)
- ✅ Gestión de archivos en AWS S3
- ✅ Notificaciones automáticas por email
- ✅ Firma electrónica de contratos (módulo ESIGN)
- ✅ Sistema de evaluación y contratación
- ✅ Gestión de pagos mensuales
- ✅ Auditoría completa de eventos

### 1.2 Métricas del Proyecto

| Métrica | Valor |
|---------|-------|
| **Total de Módulos Principales** | 15 módulos |
| **Modelos de Base de Datos** | 26+ modelos |
| **Migraciones de Base de Datos** | 60+ migraciones |
| **Líneas Aproximadas de Documentación** | 1,561 líneas (README) + 20+ docs |
| **Controladores Identificados** | 15+ controladores |
| **Servicios Principales** | 15+ servicios |
| **Total de Dependencias** | 26 dependencias de producción |
| **Total de Dependencias de Desarrollo** | 22 dependencias de desarrollo |

### 1.3 Estado del Proyecto

- ✅ **Estado:** En producción activa
- ✅ **Madurez:** Sistema consolidado con múltiples iteraciones
- ✅ **Última Migración:** Diciembre 2025 (Payment Inboxes)
- ✅ **Deployment:** Automatizado mediante GitHub Actions

---

## 2. STACK TECNOLÓGICO

### 2.1 Framework y Runtime

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **NestJS** | 11.0.1 | Framework principal del backend |
| **Node.js** | Compatible con ES2023 | Runtime de JavaScript |
| **TypeScript** | 5.7.3 | Lenguaje de programación tipado |
| **Express** | (vía NestJS) | Servidor HTTP subyacente |

**Justificación de la Elección:**
- NestJS 11 proporciona arquitectura modular escalable
- TypeScript garantiza type-safety en toda la aplicación
- Express es el estándar de facto para APIs en Node.js

### 2.2 Base de Datos

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **PostgreSQL** | 15+ | Base de datos relacional principal |
| **Prisma Client** | 6.4.1 | ORM moderno para TypeScript |
| **Prisma CLI** | 6.14.0 | Herramienta de migraciones |
| **pg** | 8.16.3 | Driver nativo de PostgreSQL |
| **pg-query-stream** | 4.10.3 | Streaming de queries |

**Características Destacadas:**
- ✅ Uso de UUIDs como identificadores primarios
- ✅ Relaciones complejas entre 25+ modelos
- ✅ Enums tipados para estados y clasificaciones
- ✅ Soft deletes mediante campo `activo`
- ✅ Auditoría automática con `fechaCreacion` y `fechaActualizacion`

### 2.3 Autenticación y Seguridad

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **@nestjs/jwt** | 11.0.0 | Manejo de JSON Web Tokens |
| **bcryptjs** | 2.4.3 | Hashing de contraseñas |
| **helmet** | 8.0.0 | Headers de seguridad HTTP |
| **@nestjs/throttler** | 6.4.0 | Rate limiting y protección DDoS |

### 2.4 Validación y Transformación

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **class-validator** | 0.14.1 | Validación de DTOs |
| **class-transformer** | 0.5.1 | Transformación de objetos |
| **joi** | 17.13.3 | Validación de esquemas de configuración |

### 2.5 Infraestructura Cloud

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **aws-sdk** | 2.1692.0 | Integración con AWS S3 |
| **archiver** | 7.0.1 | Creación de archivos ZIP |
| **sharp** | 0.33.4 | Procesamiento de imágenes |
| **puppeteer** | 23.0.0 | Generación de PDFs y web scraping |
| **pdf-lib** | 1.17.1 | Manipulación de PDFs |

### 2.6 Comunicaciones

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **nodemailer** | 7.0.5 | Envío de correos electrónicos |
| **@nestjs/schedule** | 6.0.0 | Tareas programadas (cron jobs) |
| **exceljs** | 4.4.0 | Generación de reportes Excel |

### 2.7 Documentación y Testing

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **@nestjs/swagger** | 11.0.6 | Documentación automática OpenAPI |
| **jest** | 29.7.0 | Framework de testing |
| **supertest** | 7.0.0 | Testing de APIs HTTP |
| **ts-jest** | 29.2.5 | Integración Jest con TypeScript |

### 2.8 Herramientas de Desarrollo

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **ESLint** | 9.18.0 | Linting de código |
| **Prettier** | 3.4.2 | Formateo automático |
| **@swc/core** | 1.10.7 | Compilador rápido (alternativa a tsc) |
| **typescript-eslint** | 8.20.0 | ESLint para TypeScript |

---

## 3. ARQUITECTURA DEL SISTEMA

### 3.1 Patrón Arquitectónico

El proyecto sigue la arquitectura **Modular en Capas** de NestJS:

```
┌─────────────────────────────────────────────────────┐
│              CAPA DE PRESENTACIÓN                    │
│  (Controllers + Swagger Documentation)               │
├─────────────────────────────────────────────────────┤
│              CAPA DE APLICACIÓN                      │
│  (Services + Business Logic)                         │
├─────────────────────────────────────────────────────┤
│              CAPA DE DOMINIO                         │
│  (Entities + DTOs + Enums)                           │
├─────────────────────────────────────────────────────┤
│              CAPA DE INFRAESTRUCTURA                 │
│  (Prisma + AWS S3 + Email + External APIs)           │
└─────────────────────────────────────────────────────┘
```

### 3.2 Módulos de Sistema (Core)

```typescript
AppModule (Raíz)
├── ConfigModule (Global)
│   ├── Environment Validation
│   └── Configuration Services
├── ThrottlerModule (Global Rate Limiting)
├── PrismaModule (Global Database)
└── HttpExceptionFilter (Global Error Handling)
```

### 3.3 Principios de Diseño Implementados

1. **Separación de Responsabilidades (SoC)**
   - Cada módulo tiene una responsabilidad única y bien definida
   - Controllers manejan HTTP, Services manejan lógica de negocio

2. **Inyección de Dependencias (DI)**
   - Uso extensivo del sistema DI de NestJS
   - Facilita testing y mantenibilidad

3. **Single Source of Truth**
   - Prisma Schema como única fuente de verdad para el modelo de datos
   - Client generado automáticamente

4. **API First Design**
   - Swagger/OpenAPI para documentación automática
   - Contratos de API bien definidos con DTOs

5. **Feature Flags**
   - Sistema de flags para rollout controlado de features
   - Permite rollback inmediato sin redeploy

---

## 4. ESTRUCTURA DEL PROYECTO

### 4.1 Organización de Directorios

```
API-ANDES/
│
├── src/                          # Código fuente principal
│   ├── main.ts                   # Entry point de la aplicación
│   ├── app.module.ts             # Módulo raíz
│   │
│   ├── admin/                    # Gestión administrativa
│   │   ├── admin.controller.ts
│   │   ├── admin.service.ts
│   │   ├── contract-monitoring.controller.ts
│   │   ├── contract-webhook-logging.service.ts
│   │   └── webhooks.controller.ts
│   │
│   ├── applications/             # Gestión de postulaciones
│   ├── auth/                     # Autenticación y autorización
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── auth.utils.ts
│   │   ├── dto/
│   │   └── entities/
│   │
│   ├── common/                   # Utilidades compartidas
│   ├── companies/                # Gestión de empresas
│   ├── config/                   # Configuraciones
│   │   ├── environments.config.ts
│   │   ├── upload.config.ts
│   │   └── swagger.config.ts
│   │
│   ├── email/                    # Servicio de correos
│   ├── email-templates/          # Plantillas de email
│   ├── esign/                    # Firma electrónica (Feature Flag)
│   │   └── esign.controller.ts
│   │
│   ├── files/                    # Gestión de archivos (S3)
│   ├── notifications/            # Sistema de notificaciones
│   ├── offers/                   # Gestión de ofertas/propuestas
│   ├── prisma/                   # Módulo de Prisma
│   │   ├── prisma.service.ts
│   │   └── prisma.module.ts
│   │
│   ├── s3-cleanup/               # Limpieza automática de S3
│   ├── users/                    # Gestión de usuarios (general)
│   └── usuarios/                 # Gestión de usuarios (específico)
│
├── prisma/
│   ├── schema.prisma             # Esquema de base de datos (718 líneas)
│   └── migrations/               # 60+ migraciones
│       ├── migration_lock.toml
│       └── [timestamps]/
│
├── docs/                         # Documentación técnica (20+ archivos)
│   ├── ADMIN_PASSWORD_RESET.md
│   ├── AWS_S3_FILE_SERVICE_GUIDE.md
│   ├── CONTRACT_CANCELLATION_SYSTEM.md
│   ├── DB_BACKUP.md
│   ├── ESIGN_MODULE_README.md
│   ├── FEATURE_FLAGS.md
│   ├── MIGRATIONS.md
│   ├── PRISMA_MIGRATIONS_RUNBOOK.md
│   └── S3_CLEANUP_SYSTEM.md
│
├── sql/
│   └── predeploy/                # Scripts SQL pre-deploy
│       ├── 001_archive_columns.sql
│       ├── 002_fix_duplicados_empleado_empresa.sql
│       ├── 003_create_unique_index.sql
│       └── 004_drop_unique_usuario_responsable.sql
│
├── test/                         # Tests end-to-end
│   ├── app.e2e-spec.ts
│   └── jest-e2e.json
│
├── backups/                      # Backups de base de datos
│   ├── andes-prod-20251113-043901.dump
│   └── andes-test-20251113-043826.dump
│
├── scripts/                      # Scripts de migración y mantenimiento
│   ├── batch-migrate-contracts.ts
│   └── run-predeploy.js
│
├── .github/
│   └── workflows/
│       └── deploy.yml            # CI/CD Pipeline
│
├── package.json                  # Dependencias y scripts
├── tsconfig.json                 # Configuración TypeScript
├── nest-cli.json                 # Configuración NestJS
├── eslint.config.mjs             # Configuración ESLint
├── .env.example                  # Plantilla de variables de entorno
└── README.md                     # Documentación principal (1561 líneas)
```

### 4.2 Convenciones de Nombres

| Tipo | Patrón | Ejemplo |
|------|--------|---------|
| **Controladores** | `*.controller.ts` | `auth.controller.ts` |
| **Servicios** | `*.service.ts` | `auth.service.ts` |
| **Módulos** | `*.module.ts` | `auth.module.ts` |
| **DTOs** | `*.dto.ts` | `create-user.dto.ts` |
| **Entities** | `*.entity.ts` | `user.entity.ts` |
| **Guards** | `*.guard.ts` | `jwt-auth.guard.ts` |
| **Filters** | `*.filter.ts` | `http-exception.filter.ts` |
| **Pipes** | `*.pipe.ts` | `validation.pipe.ts` |
| **Tests** | `*.spec.ts` | `auth.service.spec.ts` |
| **E2E Tests** | `*.e2e-spec.ts` | `app.e2e-spec.ts` |

---

## 5. MÓDULOS FUNCIONALES

### 5.1 Módulo de Autenticación (`auth`)

**Responsabilidad:** Gestión de autenticación y autorización de usuarios

**Componentes:**
- `auth.controller.ts`: Endpoints de login, registro, verificación
- `auth.service.ts`: Lógica de autenticación JWT
- `auth.utils.ts`: Utilidades de validación y hashing

**Funcionalidades:**
- ✅ Login con JWT (expiración configurable: 7 días por defecto)
- ✅ Registro de usuarios con validación de roles
- ✅ Reset de contraseña con tokens temporales
- ✅ Validación de cuentas por email
- ✅ Hashing seguro con bcryptjs (10 rounds)

**Endpoints Principales:**
- `POST /api/auth/login`
- `POST /api/auth/register`
- `POST /api/auth/reset-password`
- `POST /api/auth/verify-email`

### 5.2 Módulo de Usuarios (`usuarios` + `users`)

**Nota:** Existen dos módulos separados (probablemente herencia de refactor)

**Responsabilidad:** Gestión del perfil y datos de usuarios

**Funcionalidades:**
- ✅ CRUD completo de usuarios
- ✅ Gestión de perfil (educación, experiencia, habilidades)
- ✅ Carga de documentos (CV, foto perfil, video presentación)
- ✅ Validación de perfil completo
- ✅ Clasificación de postulantes (ACTIVE, BLACKLIST, FAVORITE, etc.)
- ✅ Gestión de datos bancarios
- ✅ Sistema de roles múltiples

**Endpoints Principales:**
- `GET /api/usuarios`
- `GET /api/usuarios/:id`
- `PATCH /api/usuarios/:id`
- `POST /api/usuarios/:id/educacion`
- `POST /api/usuarios/:id/experiencia`

### 5.3 Módulo de Empresas (`companies`)

**Responsabilidad:** Gestión de empresas clientes

**Funcionalidades:**
- ✅ CRUD de empresas
- ✅ Asignación de responsables/representantes
- ✅ Gestión de empleados de empresa
- ✅ Clasificación personalizada de postulantes por empresa
- ✅ Asociación con propuestas/ofertas

**Relaciones:**
- Empresa → Usuario Responsable (1:1)
- Empresa → Empleados Empresa (1:N)
- Empresa → Clasificaciones Postulantes (1:N)
- Empresa → Propuestas Asociadas (N:M)

### 5.4 Módulo de Ofertas/Propuestas (`offers`)

**Responsabilidad:** Gestión del catálogo de ofertas laborales

**Funcionalidades:**
- ✅ Creación de propuestas de empleo
- ✅ Propuestas reutilizables (templates)
- ✅ Gestión de posiciones abiertas vs cubiertas
- ✅ Filtrado por departamento, seniority, país, modalidad
- ✅ Asociación múltiple con empresas
- ✅ Estados: activa, inactiva, cerrada

**Campos Principales:**
```typescript
{
  titulo: string;
  descripcion: string;
  requerimientos: string;
  departamento: string;
  seniority: string;
  pais: string;
  modalidad: ModalidadTrabajo; // REMOTO, HIBRIDO, PRESENCIAL
  cantidadPosiciones: number;
  posicionesCubiertas: number;
  reutilizable: boolean;
}
```

### 5.5 Módulo de Postulaciones (`applications`)

**Responsabilidad:** Gestión del ciclo de vida de las postulaciones

**Funcionalidades:**
- ✅ Creación de postulaciones candidato → propuesta
- ✅ Seguimiento de estados múltiples (10 estados)
- ✅ Sistema de etapas (Etapa 1, 2, 3)
- ✅ Notas internas por postulación
- ✅ Documentos de postulación
- ✅ Bloqueo de postulaciones
- ✅ Gestión de entrevistas (múltiples propuestas de horarios)
- ✅ Confirmación de entrevista con zona horaria

**Estados de Postulación:**
1. PENDIENTE
2. EN_EVALUACION
3. EN_EVALUACION_CLIENTE
4. PRIMERA_ENTREVISTA_REALIZADA
5. SEGUNDA_ENTREVISTA_REALIZADA
6. FINALISTA
7. ACEPTADA
8. RECHAZADA

**Funcionalidades de Entrevista:**
- Empresa propone hasta 3 horarios con zona horaria IANA
- Candidato confirma uno de los horarios
- Sistema registra fecha confirmada

### 5.6 Módulo de Administración (`admin`)

**Responsabilidad:** Funciones administrativas y monitoreo

**Componentes:**
- `admin.controller.ts`: Endpoints administrativos generales
- `contract-monitoring.controller.ts`: Monitoreo de contratos
- `contract-webhook-logging.service.ts`: Logging de webhooks
- `webhooks.controller.ts`: Recepción de webhooks externos

**Funcionalidades:**
- ✅ Reset de contraseñas de usuarios por admin
- ✅ Gestión de empleados admin
- ✅ Monitoreo de procesos de contratación
- ✅ Recepción de webhooks de SignWell (firma electrónica)
- ✅ Logging detallado de eventos de contratos
- ✅ Dashboard de métricas

### 5.7 Módulo de Firma Electrónica (`esign`) ⭐ FEATURE FLAG

**Responsabilidad:** Sistema interno de firma electrónica de contratos

**Estado:** Controlado por feature flag `ENABLE_ESIGN`

**Funcionalidades:**
- ✅ Creación de documentos para firma
- ✅ Sistema de plantillas reutilizables
- ✅ Múltiples firmantes (orden secuencial)
- ✅ Campos de firma posicionables (coordenadas proporcionales)
- ✅ Tokens únicos de firma
- ✅ Auditoría completa de eventos
- ✅ Gestión de estados (DRAFT, SENT, IN_PROGRESS, COMPLETED, etc.)
- ✅ Soporte para anexos
- ✅ Variables dinámicas en plantillas

**Modelos del Sistema ESIGN:**
```typescript
SignatureDocument {
  - Documento principal con plantilla opcional
  - Estados: TEMPLATE, DRAFT, SENT, IN_PROGRESS, COMPLETED, EXPIRED, CANCELLED
  - Variables para plantillas (definiciones y valores)
}

SignatureRecipient {
  - Firmantes con orden secuencial
  - Estados: PENDING, VIEWED, SIGNED, DECLINED
  - Token único para firma
  - Expiración configurable
}

SignatureField {
  - Campos posicionables (x, y, width, height proporcionales)
  - Tipos: SIGNATURE, INITIAL, DATE, TEXT
  - Asignación a receptor específico
}

SignatureAudit {
  - Registro de eventos: SIGNED, VIEWED, SENT, DECLINED, FINALIZED, DOWNLOAD
  - IP, User Agent, Metadata
}
```

**Integración con Contratación:**
- Relación opcional con ProcesoContratacion
- Soporte para contratos principales + anexos
- Reemplaza/complementa integración con SignWell

### 5.8 Módulo de Gestión de Archivos (`files`)

**Responsabilidad:** Upload, storage y gestión de archivos en AWS S3

**Funcionalidades:**
- ✅ Upload de archivos a S3
- ✅ Generación de URLs pre-firmadas
- ✅ Validación de tipos MIME
- ✅ Compresión de imágenes con Sharp
- ✅ Generación de thumbnails
- ✅ Control de tamaños máximos
- ✅ Organización en buckets por tipo

**Tipos de Archivos Soportados:**
- Fotos de perfil
- Videos de presentación
- Currículums (PDF)
- Documentos de identidad (frente/dorso)
- Documentos de postulación
- Imágenes de requisitos técnicos
- Screenshots de tests de velocidad
- Contratos firmados

### 5.9 Módulo de Limpieza S3 (`s3-cleanup`)

**Responsabilidad:** Limpieza automática de archivos huérfanos en S3

**Funcionalidades:**
- ✅ Cron job configurable (Domingos 01:00 AM Argentina)
- ✅ Detección de archivos no referenciados en BD
- ✅ Backup antes de eliminar
- ✅ Reportes por email
- ✅ Métricas de espacio liberado
- ✅ Control por feature flag `CLEAR_STORAGE_DAILY`

**Proceso:**
1. Escaneo de todos los archivos en S3
2. Cross-reference con referencias en Prisma
3. Identificación de huérfanos
4. Backup en tabla S3CleanupBackup
5. Eliminación selectiva
6. Reporte a administradores

### 5.10 Módulo de Notificaciones (`notifications`)

**Responsabilidad:** Sistema de notificaciones in-app

**Funcionalidades:**
- ✅ Notificaciones push en la aplicación
- ✅ Tipos múltiples (8 tipos)
- ✅ Marcado de leído/no leído
- ✅ Asociación con postulaciones
- ✅ Notificaciones por cambio de estado
- ✅ Mensajes administrativos

**Tipos de Notificación:**
1. CAMBIO_ESTADO_POSTULACION
2. NUEVA_PROPUESTA
3. PERFIL_INCOMPLETO
4. FORMULARIO_PENDIENTE
5. VALIDACION_CUENTA
6. MENSAJE_ADMINISTRATIVO
7. ENTREVISTA_PROGRAMADA

### 5.11 Módulo de Email (`email` + `email-templates`)

**Responsabilidad:** Envío de correos electrónicos y gestión de plantillas

**Funcionalidades:**
- ✅ Sistema de plantillas con variables dinámicas
- ✅ Envío con Nodemailer
- ✅ Logging de emails (EmailLog)
- ✅ Reintentos automáticos en fallos
- ✅ Templates HTML y texto plano
- ✅ Variables reemplazables

**Tipos de Email:**
1. PASSWORD_RESET
2. WELCOME
3. VERIFICATION
4. NOTIFICATION
5. ADMIN_RESET
6. S3_CLEANUP
7. EMPLOYEE_CREDENTIALS

**Sistema de Logging:**
```typescript
EmailLog {
  tipoEmail: TipoEmail;
  asunto: string;
  estado: EstadoEmail; // ENVIADO, FALLIDO, PENDIENTE, REINTENTANDO
  errorMessage: string;
  intentos: number;
  metadata: Json;
}
```

### 5.12 Módulo de Procesos de Contratación (ProcesoContratacion)

**Responsabilidad:** Gestión del flujo de contratación post-aceptación

**Funcionalidades:**
- ✅ Estados de contratación (11 estados)
- ✅ Lectura de documentos (políticas, beneficios, reglamento)
- ✅ Integración con SignWell (legacy)
- ✅ Integración con ESIGN (nuevo)
- ✅ Tracking de firmas (candidato + proveedor)
- ✅ URLs de contrato final
- ✅ Evaluaciones de pago mensual
- ✅ Historial de envíos al proveedor

**Estados de Contratación:**
1. PENDIENTE_DOCUMENTOS
2. DOCUMENTOS_EN_LECTURA
3. DOCUMENTOS_COMPLETADOS
4. PENDIENTE_FIRMA_CANDIDATO
5. FIRMADO_CANDIDATO
6. LECTURA_DOCS_COMPLETA
7. PENDIENTE_FIRMA_PROVEEDOR
8. FIRMADO_COMPLETO
9. CONTRATO_FINALIZADO
10. CANCELADO
11. EXPIRADO

**Evaluaciones de Pago Mensual:**
- Modelo `EvaluacionPagoMensual`
- Tracking por año-mes
- Habilitación/deshabilitación de pagos
- Revisión de documentos de pago
- Observaciones por evaluador

### 5.13 Módulo de Payment Inboxes (Reciente - Dic 2025)

**Responsabilidad:** Gestión de facturas/inboxes de pago

**Funcionalidades:**
- ✅ Generación de datos de facturas
- ✅ Render bajo demanda (no almacena PDFs)
- ✅ Numeración automática de invoices
- ✅ Múltiples monedas
- ✅ Templates configurables
- ✅ Asociación con proceso de contratación

**Modelo:**
```typescript
PaymentInbox {
  usuarioId: string;
  procesoContratacionId: string;
  añoMes: string; // formato: YYYY-MM
  invoiceNumber: string;
  currency: string; // USD, etc.
  amount: Decimal;
  amountWords: string; // "One thousand dollars"
  status: string; // PENDING, PAID, etc.
  templateKey: string;
  dataJson: Json; // datos completos para render
}
```

### 5.14 Módulo de Bitácora (`BitacoraPostulante`)

**Responsabilidad:** Auditoría y tracking de eventos

**Funcionalidades:**
- ✅ Registro automático de eventos del sistema
- ✅ Tracking de acciones de usuarios
- ✅ Metadatos en JSON
- ✅ Asociación con usuario y postulación
- ✅ Registro de creador del evento

**Tipos de Eventos:**
1. REGISTRO_USUARIO
2. ACTUALIZACION_PERFIL
3. COMPLETADO_PERFIL
4. POSTULACION_CREADA
5. CAMBIO_ESTADO_POSTULACION
6. VALIDACION_CUENTA
7. RECHAZO_POSTULACION
8. CONTRATACION
9. BLOQUEO_POSTULACIONES
10. DESBLOQUEO_POSTULACIONES
11. ACCION_ADMINISTRATIVA
12. NOTA_MANUAL
13. CLASIFICACION_ACTIVE
14. CLASIFICACION_INACTIVE
15. CLASIFICACION_BLACKLIST

### 5.15 Módulo de Holidays

**Responsabilidad:** Gestión de días festivos por país

**Funcionalidades:**
- ✅ Registro de feriados por país
- ✅ Activación/desactivación de feriados
- ✅ Búsqueda por país y código de país
- ✅ Control de duplicados por país/día/mes
- ✅ Auditoría de fechas de creación y actualización

**Modelo:**
```typescript
Holiday {
  id: UUID (PK)
  nombre: string
  pais: string
  codigoPais: string
  activo: boolean
  dia: number (1-31)
  mes: number (1-12)
  fechaCreacion: DateTime
  fechaActualizacion: DateTime
}
```

**Índices:**
- ✅ Unique constraint: [pais, dia, mes]
- ✅ Index: activo
- ✅ Index: codigoPais
- ✅ Index: pais

---

## 6. MODELO DE DATOS

### 6.1 Entidades Principales

#### 6.1.1 Usuario (Core Entity)

**Campos Principales:**
```typescript
Usuario {
  id: UUID (PK)
  correo: string (UNIQUE)
  contrasena: string (hashed)
  rol: Rol (enum)
  roles: Rol[] (array, soporta multi-rol)
  validado: boolean
  perfilCompleto: EstadoCompletitud
  activo: boolean
  
  // Información Personal
  nombre: string
  apellido: string
  telefono: string
  residencia: string
  pais: string
  paisImagen: string (bandera)
  
  // Documentos
  fotoPerfil: string (S3 URL)
  videoPresentacion: string (S3 URL)
  curriculum: string (S3 URL)
  fotoCedulaFrente: string (S3 URL)
  fotoCedulaDorso: string (S3 URL)
  documentosAdicionales: string[] (S3 URLs)
  
  // Requisitos Técnicos
  tipoDispositivo: TipoDispositivo
  cantidadRAM: string
  proveedorInternet: string
  velocidadDescarga: string
  conexionCableada: boolean
  imagenRequerimientosPC: string
  imagenTestVelocidad: string
  
  // Información Bancaria
  bancoNombre: string
  bancoPais: string
  numeroCuentaBancaria: string
  numeroRutaBancaria: string
  direccionBanco: string
  dollarTag: string
  usaDollarApp: boolean
  nombreTitularCuenta: string
  
  // Flags y Estados
  clasificacionGlobal: ClasificacionPostulante
  notasClasificacionGlobal: string
  favorite: boolean
  assessmentUrl: string
  entrevistaPreliminar: boolean
  fechaEntrevistaPreliminar: DateTime
  postulacionesActivas: boolean
  aceptaPoliticaDatos: boolean
  
  // Reset de Contraseña
  passwordResetToken: string
  passwordResetExpires: DateTime
  
  // Relaciones (25+ relaciones)
  educacion: Educacion[]
  experiencia: Experiencia[]
  habilidades: Habilidad[]
  postulaciones: Postulacion[]
  propuestasCreadas: Propuesta[]
  notificaciones: Notificacion[]
  bitacora: BitacoraPostulante[]
  clasificacionesEmpresa: ClasificacionEmpresa[]
  // ... y más
}
```

#### 6.1.2 Propuesta (Oferta Laboral)

**Campos:**
```typescript
Propuesta {
  id: UUID (PK)
  titulo: string
  descripcion: string
  requerimientos: string
  reutilizable: boolean (template flag)
  creadaPorId: UUID (FK → Usuario)
  estado: string
  activo: boolean
  
  // Clasificación
  departamento: string
  seniority: string
  pais: string
  modalidad: ModalidadTrabajo // REMOTO | HIBRIDO | PRESENCIAL
  
  // Gestión de Posiciones
  cantidadPosiciones: number
  posicionesCubiertas: number
  
  // Relaciones
  postulaciones: Postulacion[]
  empresasAsociadas: PropuestaEmpresa[]
  creadaPor: Usuario
  actualizadoPor: Usuario
}
```

#### 6.1.3 Postulacion

**Campos:**
```typescript
Postulacion {
  id: UUID (PK)
  propuestaId: UUID (FK → Propuesta)
  candidatoId: UUID (FK → Usuario)
  estadoPostulacion: EstadoPostulacion
  fechaPostulacion: DateTime
  
  // Etapas
  fechaEtapa1: DateTime
  fechaEtapa2: DateTime
  fechaEtapa3: DateTime
  
  // Gestión de Entrevistas
  preferenciaEntrevista: boolean
  disponibilidadEntrevista: DateTime
  disponibilidadEntrevista2: DateTime
  disponibilidadEntrevista3: DateTime
  zonaHorariaEntrevista: string (IANA timezone)
  fechaEntrevistaConfirmada: DateTime
  
  // Información Adicional
  notasInternas: string
  cv: string (S3 URL)
  documentosPostulacion: string[]
  bloqueada: boolean
  bloqueadaPor: string
  activo: boolean
  
  // Relaciones
  candidato: Usuario
  propuesta: Propuesta
  bitacora: BitacoraPostulante[]
  notificaciones: Notificacion[]
  procesosContratacion: ProcesoContratacion[]
  postulacionesEmpresa: PostulacionPropuestaEmpresa[]
}
```

#### 6.1.4 Empresa

**Campos:**
```typescript
Empresa {
  id: UUID (PK)
  nombre: string
  descripcion: string
  usuarioResponsableId: UUID (FK → Usuario, nullable)
  activo: boolean
  
  // Relaciones
  usuarioResponsable: Usuario
  empleados: EmpleadoEmpresa[]
  propuestasAsociadas: PropuestaEmpresa[]
  clasificacionesPostulantes: ClasificacionEmpresa[]
}
```

#### 6.1.5 ProcesoContratacion

**Campos:**
```typescript
ProcesoContratacion {
  id: UUID (PK)
  postulacionId: UUID (FK → Postulacion)
  estadoContratacion: EstadoContratacion
  fechaInicio: DateTime
  fechaFinalizacion: DateTime
  
  // Información del Contrato
  nombreCompleto: string
  puestoTrabajo: string
  ofertaSalarial: Decimal
  monedaSalario: string
  fechaInicioLabores: DateTime
  
  // Firma Electrónica (SignWell - Legacy)
  signWellDocumentId: string
  signWellDownloadUrl: string
  signWellUrlCandidato: string
  signWellUrlProveedor: string
  documentoFirmado: string (S3 URL)
  fechaFirma: DateTime
  fechaFirmaCandidato: DateTime
  fechaFirmaProveedor: DateTime
  
  // Firma Electrónica (ESIGN - Nuevo)
  esignDocumentId: UUID (FK → SignatureDocument, unique)
  
  // Lectura de Documentos
  beneficiosLeido: boolean
  beneficiosFechaLeido: DateTime
  contratoLeido: boolean (deprecated)
  contratoFechaLeido: DateTime (deprecated)
  introduccionLeido: boolean
  introduccionFechaLeido: DateTime
  politicasLeido: boolean
  politicasFechaLeido: DateTime
  reglamentoLeido: boolean
  reglamentoFechaLeido: DateTime
  
  // Gestión con Proveedor
  contratoFinalUrl: string
  enviadoAlProveedor: boolean
  enviadoPorUsuarioId: UUID (FK → Usuario)
  fechaEnvioAlProveedor: DateTime
  
  activo: boolean
  
  // Relaciones
  postulacion: Postulacion
  esignDocument: SignatureDocument
  anexos: SignatureDocument[]
  webhookLogs: ContractWebhookLog[]
  evaluacionesPago: EvaluacionPagoMensual[]
  historialEnviosProveedor: HistorialEnvioProveedor[]
  paymentInboxes: PaymentInbox[]
}
```

#### 6.1.9 Holiday

**Campos:**
```typescript
Holiday {
  id: UUID (PK)
  nombre: string
  pais: string
  codigoPais: string
  activo: boolean
  fechaCreacion: DateTime
  fechaActualizacion: DateTime
  dia: number (1-31)
  mes: number (1-12)
}

@@unique([pais, dia, mes])
@@index([activo])
@@index([codigoPais])
@@index([pais])
```

### 6.2 Relaciones Complejas

#### 6.2.1 Many-to-Many con Tabla Intermedia

**Propuesta ↔ Empresa:**
```typescript
PropuestaEmpresa {
  id: UUID (PK)
  propuestaId: UUID (FK)
  empresaId: UUID (FK)
  fechaAsociacion: DateTime
  activo: boolean
  visibleToClient: boolean
  
  // Relaciones
  propuesta: Propuesta
  empresa: Empresa
  postulaciones: PostulacionPropuestaEmpresa[]
}

@@unique([propuestaId, empresaId])
```

**Postulación ↔ PropuestaEmpresa:**
```typescript
PostulacionPropuestaEmpresa {
  id: UUID (PK)
  postulacionId: UUID (FK)
  propuestaEmpresaId: UUID (FK)
  fechaRegistro: DateTime
  
  @@unique([postulacionId, propuestaEmpresaId])
}
```

#### 6.2.2 Self-References

**SignatureDocument (Plantillas):**
```typescript
SignatureDocument {
  templateSourceId: UUID (FK → SignatureDocument, self)
  templateSource: SignatureDocument (parent template)
  instances: SignatureDocument[] (derived instances)
  
  @@relation("TemplateHierarchy")
}
```

#### 6.2.3 One-to-One Opcionales

**ProcesoContratacion ↔ SignatureDocument:**
```typescript
// Un proceso puede tener un documento principal de firma
ProcesoContratacion {
  esignDocumentId: UUID @unique (nullable)
  esignDocument: SignatureDocument
}
```

### 6.3 Enums del Sistema

#### 6.3.1 Rol (Multi-Role Support)

```typescript
enum Rol {
  CANDIDATO
  EMPRESA
  ADMIN
  EMPLEADO_ADMIN
  EMPLEADO_EMPRESA
  ADMIN_RECLUTAMIENTO
}

// Usuario ahora soporta:
rol: Rol (legacy, single)
roles: Rol[] (nuevo, multi-rol)
```

#### 6.3.2 Estados de Postulación

```typescript
enum EstadoPostulacion {
  PENDIENTE
  EN_EVALUACION
  FINALISTA
  ACEPTADA
  RECHAZADA
  EN_EVALUACION_CLIENTE
  PRIMERA_ENTREVISTA_REALIZADA
  SEGUNDA_ENTREVISTA_REALIZADA
}
```

#### 6.3.3 Estados de Contratación

```typescript
enum EstadoContratacion {
  PENDIENTE_DOCUMENTOS
  DOCUMENTOS_EN_LECTURA
  DOCUMENTOS_COMPLETADOS
  PENDIENTE_FIRMA_CANDIDATO
  FIRMADO_CANDIDATO
  LECTURA_DOCS_COMPLETA
  PENDIENTE_FIRMA_PROVEEDOR
  FIRMADO_COMPLETO
  CONTRATO_FINALIZADO
  CANCELADO
  EXPIRADO
}
```

#### 6.3.4 Clasificación de Postulantes

```typescript
enum ClasificacionPostulante {
  ACTIVE      // Activo, puede postular
  BLACKLIST   // Bloqueado permanentemente
  DISMISS     // Descartado temporalmente
  FAVORITE    // Favorito, alta prioridad
  INACTIVE    // Inactivo, no disponible
}
```

#### 6.3.5 Estados de Firma Electrónica (ESIGN)

```typescript
enum SignatureState {
  TEMPLATE      // Es una plantilla reutilizable
  DRAFT         // Borrador, en edición
  SENT          // Enviado a firmantes
  IN_PROGRESS   // En proceso de firmas
  COMPLETED     // Todas las firmas completadas
  EXPIRED       // Expirado
  CANCELLED     // Cancelado
}

enum RecipientState {
  PENDING       // Pendiente de firma
  VIEWED        // Visto pero no firmado
  SIGNED        // Firmado
  DECLINED      // Rechazado
}

enum FieldType {
  SIGNATURE     // Campo de firma
  INITIAL       // Iniciales
  DATE          // Fecha
  TEXT          // Texto libre
}
```

### 6.4 Índices y Optimizaciones

El esquema incluye múltiples índices para optimizar queries:

```prisma
// Índices en Postulacion
@@index([candidatoId])
@@index([propuestaId])

// Índices en SignatureDocument
@@index([createdById])
@@index([templateSourceId])

// Índices en ContractWebhookLog
@@index([processId])
@@index([documentId])
@@index([eventType])
@@index([timestamp])
@@index([success])

// Índices en S3CleanupBackup
@@index([executionDate])
@@index([backupStatus])
@@index([createdAt])
```

### 6.5 Constraints Únicos

```prisma
// Usuario
@@unique([correo])

// Habilidad
@@unique([usuarioId, nombre])

// EmpleadoEmpresa
@@unique([usuarioId, empresaId])

// ClasificacionEmpresa
@@unique([postulanteId, empresaId])

// PropuestaEmpresa
@@unique([propuestaId, empresaId])

// PostulacionPropuestaEmpresa
@@unique([postulacionId, propuestaEmpresaId])

// EvaluacionPagoMensual
@@unique([procesoContratacionId, añoMes])

// PaymentInbox
@@unique([procesoContratacionId, añoMes])
```

---

## 7. SEGURIDAD Y AUTENTICACIÓN

### 7.1 Sistema de Autenticación

**Tipo:** JWT (JSON Web Tokens)

**Configuración:**
```typescript
JWT_SECRET: string (variable de entorno)
JWT_EXPIRATION_TIME: "7d" (7 días por defecto)
```

**Flow de Autenticación:**
```
1. Usuario envía credenciales → POST /api/auth/login
2. Servidor valida con bcryptjs
3. Si válido → genera JWT con payload:
   {
     sub: usuarioId,
     email: correo,
     rol: rol,
     roles: roles[]
   }
4. Cliente almacena token
5. Requests subsecuentes incluyen: Authorization: Bearer <token>
6. Guards de NestJS validan token en cada request
```

### 7.2 Hashing de Contraseñas

**Librería:** bcryptjs
**Rounds:** 10 (configuración estándar)

```typescript
// Hash al registrar
const hashedPassword = await bcrypt.hash(password, 10);

// Verificación al login
const isValid = await bcrypt.compare(password, hashedPassword);
```

### 7.3 Rate Limiting

**Configuración (Throttler):**
```typescript
{
  ttl: 60000,    // 60 segundos
  limit: 10      // 10 requests máximo
}
```

**Protección contra:**
- ✅ Brute force attacks
- ✅ DDoS básicos
- ✅ Spam de endpoints

### 7.4 Headers de Seguridad (Helmet)

Helmet configura automáticamente headers HTTP seguros:
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `Strict-Transport-Security`
- `Content-Security-Policy`

### 7.5 CORS

**Orígenes Permitidos:**
```typescript
[
  'https://test.andes-workforce.app.appwiseinnovations.com',
  'https://andes-workforce.com',
  'https://andes.client.andes-workforce.com',
  'https://www.andes-workforce.com',
  'https://andesworkforce.com',
  'https://www.andesworkforce.com',
  'https://preview.test.andes-workforce.com',
  'http://localhost:3000',
  'http://localhost:3001',
  'http://localhost:3002'
]
```

**Métodos Permitidos:**
- GET, POST, PUT, DELETE, OPTIONS, PATCH, HEAD

**Credentials:** Habilitado (`credentials: true`)

### 7.6 Validación de DTOs

**Pipes Globales:**
```typescript
ValidationPipe({
  whitelist: true,              // Remueve propiedades no definidas
  forbidNonWhitelisted: true,   // Rechaza si hay props extras
  transform: true,              // Auto-transforma tipos
  disableErrorMessages: false,  // Mensajes detallados
  validationError: {
    target: false,              // No expone objeto completo
    value: false                // No expone valores por seguridad
  }
})
```

### 7.7 Roles y Permisos

**Sistema de Roles:**
```typescript
enum Rol {
  CANDIDATO           // Usuario regular postulante
  EMPRESA             // Empresa cliente
  ADMIN               // Administrador completo
  EMPLEADO_ADMIN      // Empleado de administración
  EMPLEADO_EMPRESA    // Empleado de empresa
  ADMIN_RECLUTAMIENTO // Admin especializado en reclutamiento
}
```

**Multi-Role Support:**
- Usuario puede tener múltiples roles simultáneos
- Array `roles[]` en modelo Usuario
- Guardas verifican cualquier rol requerido

**Guards Probables:**
- `JwtAuthGuard`: Verifica token válido
- `RolesGuard`: Verifica roles específicos
- `ThrottlerGuard`: Rate limiting

### 7.8 Reset de Contraseña Seguro

**Proceso:**
1. Usuario solicita reset → `POST /api/auth/forgot-password`
2. Sistema genera token único: `passwordResetToken`
3. Token expira en tiempo limitado: `passwordResetExpires`
4. Email con link + token
5. Usuario accede con token válido
6. Nueva contraseña → token se invalida

### 7.9 Validación de Datos

**class-validator + class-transformer:**
```typescript
// Ejemplo de DTO
export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  correo: string;

  @IsString()
  @MinLength(8)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
  contrasena: string;

  @IsEnum(Rol)
  rol: Rol;
}
```

### 7.10 Auditoría y Logging

**Registros de Seguridad:**
- Todos los logins en BitacoraPostulante
- Eventos de reset de contraseña
- Cambios de roles
- Accesos administrativos
- Webhooks de firma electrónica

**EmailLog para Emails Críticos:**
- PASSWORD_RESET
- ADMIN_RESET
- VERIFICATION

---

## 8. INTEGRACIONES EXTERNAS

### 8.1 AWS S3 (Simple Storage Service)

**Propósito:** Almacenamiento de archivos (imágenes, PDFs, videos)

**Configuración:**
```env
AWS_S3_BUCKET=your-bucket-name
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_REGION=us-east-1
```

**Operaciones:**
- ✅ Upload de archivos
- ✅ Generación de URLs pre-firmadas (seguras, temporales)
- ✅ Descarga de archivos
- ✅ Eliminación de archivos
- ✅ Listado de archivos por prefijo

**Organización de Archivos:**
```
s3://bucket-name/
├── profiles/
│   ├── photos/
│   └── videos/
├── documents/
│   ├── cvs/
│   ├── cedulas/
│   └── additional/
├── contracts/
│   ├── signed/
│   └── drafts/
├── requirements/
│   ├── pc-screenshots/
│   └── speed-tests/
└── backups/
    └── db-dumps/
```

**Sistema de Limpieza:**
- Cron job semanal (S3CleanupModule)
- Detección de archivos huérfanos
- Backup antes de eliminar
- Reportes automáticos

### 8.2 SignWell (Firma Electrónica - Legacy)

**Propósito:** Firma electrónica de contratos (sistema heredado)

**Integración:**
- Webhooks para eventos de firma
- URLs de firma para candidatos y proveedores
- Descarga de documentos firmados
- Tracking de estados de firma

**Logging:**
```typescript
ContractWebhookLog {
  webhookId: string
  documentId: string
  eventType: string
  recipientId: string
  status: string
  signedAt: DateTime
  step: string
  success: boolean
  errorMessage: string
  responseTime: number
}
```

**Endpoints de Webhooks:**
- `POST /api/admin/webhooks/signwell`

**Nota:** En proceso de migración a sistema ESIGN interno

### 8.3 Nodemailer (Email)

**Propósito:** Envío de correos electrónicos

**Configuración:**
```env
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your-email@example.com
SMTP_PASSWORD=your-password
```

**Tipos de Emails:**
1. Bienvenida
2. Verificación de cuenta
3. Reset de contraseña
4. Notificaciones de postulaciones
5. Recordatorios de documentos
6. Reportes administrativos (S3 cleanup, backups)
7. Credenciales de empleados

**Features:**
- ✅ Templates HTML con variables
- ✅ Adjuntos
- ✅ Reintentos automáticos
- ✅ Logging completo
- ✅ Queue de emails (probable)

### 8.4 Puppeteer (PDF Generation)

**Propósito:** Generación de PDFs dinámicos

**Usos Probables:**
- Generación de contratos personalizados
- Reportes en PDF
- Facturas (PaymentInbox)
- Certificados

**Configuración:**
```typescript
import puppeteer from 'puppeteer';

const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.setContent(htmlContent);
const pdf = await page.pdf({ format: 'A4' });
```

### 8.5 Sharp (Image Processing)

**Propósito:** Procesamiento y optimización de imágenes

**Operaciones:**
- ✅ Redimensionamiento
- ✅ Compresión
- ✅ Generación de thumbnails
- ✅ Conversión de formatos
- ✅ Rotación y recorte

**Ejemplo:**
```typescript
await sharp(inputBuffer)
  .resize(800, 600, { fit: 'cover' })
  .jpeg({ quality: 85 })
  .toBuffer();
```

### 8.6 ExcelJS (Reportes)

**Propósito:** Generación de reportes en Excel

**Usos:**
- Exportación de postulaciones
- Reportes de candidatos
- Estadísticas de contratación
- Resúmenes de migraciones

**Archivos Generados:**
- `import_contracts_summary.csv`
- `migrate_candidates_summary_*.csv`

---

## 9. ANÁLISIS DE DEPENDENCIAS

### 9.1 Dependencias de Producción

| Dependencia | Versión | Criticidad | Propósito |
|-------------|---------|-----------|-----------|
| **@nestjs/core** | 11.0.1 | 🔴 CRÍTICA | Framework base |
| **@prisma/client** | 6.4.1 | 🔴 CRÍTICA | ORM y base de datos |
| **bcryptjs** | 2.4.3 | 🔴 CRÍTICA | Seguridad de contraseñas |
| **@nestjs/jwt** | 11.0.0 | 🔴 CRÍTICA | Autenticación |
| **aws-sdk** | 2.1692.0 | 🟡 ALTA | Almacenamiento de archivos |
| **nodemailer** | 7.0.5 | 🟡 ALTA | Comunicación por email |
| **pg** | 8.16.3 | 🔴 CRÍTICA | Driver de PostgreSQL |
| **helmet** | 8.0.0 | 🟡 ALTA | Seguridad HTTP |
| **class-validator** | 0.14.1 | 🟡 ALTA | Validación de datos |
| **puppeteer** | 23.0.0 | 🟢 MEDIA | Generación de PDFs |
| **sharp** | 0.33.4 | 🟢 MEDIA | Procesamiento de imágenes |
| **exceljs** | 4.4.0 | 🟢 MEDIA | Reportes Excel |
| **@nestjs/schedule** | 6.0.0 | 🟢 MEDIA | Cron jobs |
| **@nestjs/throttler** | 6.4.0 | 🟡 ALTA | Rate limiting |

### 9.2 Dependencias de Desarrollo

| Dependencia | Versión | Propósito |
|-------------|---------|-----------|
| **prisma** | 6.14.0 | CLI de Prisma |
| **typescript** | 5.7.3 | Compilador TypeScript |
| **@nestjs/cli** | 11.0.0 | CLI de NestJS |
| **eslint** | 9.18.0 | Linting |
| **prettier** | 3.4.2 | Formateo |
| **jest** | 29.7.0 | Testing |
| **@swc/core** | 1.10.7 | Compilador rápido |
| **typescript-eslint** | 8.20.0 | ESLint para TS |

### 9.3 Análisis de Vulnerabilidades

**Recomendaciones:**
1. ✅ **aws-sdk** está en versión 2.x (legacy)
   - ⚠️ Considerar migración a AWS SDK v3 (modular, tree-shakeable)
   
2. ✅ **puppeteer** v23 es reciente y estable
   
3. ✅ Todas las dependencias de NestJS están alineadas en v11

4. ⚠️ **Ausencia de dependencias de testing:**
   - No se detectan mocks o fixtures configurados

### 9.4 Gestión de Versiones

**package.json - Estrategia:**
- Uso de `^` (caret) para actualizaciones de parches y minor
- Versiones exactas no forzadas (flexible para actualizaciones)

**Lockfile:**
- ✅ `pnpm-lock.yaml` presente
- Garantiza builds reproducibles

---

## 10. SISTEMA DE MIGRACIONES

### 10.1 Herramienta: Prisma Migrate

**Comando Principal:**
```bash
npx prisma migrate dev --name <nombre-descriptivo>
```

### 10.2 Historial de Migraciones (60+ migraciones)

**Línea de Tiempo:**

**Marzo 2025 - Fundación:**
- ✅ `20250310131410_new_model` - Modelos iniciales
- ✅ `20250310192924_update_models` - Actualización de modelos
- ✅ `20250311200926_add_active_field` - Campo activo
- ✅ `20250312133403_deleted_nombre_usuario` - Eliminación campo
- ✅ `20250316010245_added_form_user` - Formulario de usuario
- ✅ `20250317044448_added_search_offers` - Búsqueda de ofertas
- ✅ `20250321182157_add_pc_and_speed_test_images` - Imágenes técnicas
- ✅ `20250322115946_added_is_actual_experencie` - Experiencia actual
- ✅ `20250322183843_add_es_actual_to_educacion` - Educación actual
- ✅ `20250326030021_add_new_roles` - Nuevos roles

**Mayo 2025 - Expansión:**
- ✅ `20250505134114_added_postulacionesactivas_in_model` - Flag postulaciones
- ✅ `20250505230403_added_property_info_personal` - Info personal
- ✅ `20250509125902_added_status_postulants` - Estados de postulantes
- ✅ `20250509133634_add_global_classification` - Clasificación global
- ✅ `20250511194634_added_template_email` - Templates de email
- ✅ `20250521170556_add_foto_cedula` - Fotos de cédula
- ✅ `20250528053621_add_admin_reclutamiento_role` - Rol de reclutamiento
- ✅ `20250528064112_add_positions_to_propuesta` - Posiciones en propuestas

**Junio 2025 - Módulo de Contratación:**
- ✅ `20250611131838_add_contratacion_module` - Módulo de contratación
- ✅ `20250625023503_update_contratacion_signwell_flow` - Flujo SignWell
- ✅ `20250627081757_add_contract_states_allow_multiple_contracts` - Múltiples contratos
- ✅ `20250629200317_add_document_fields_to_contratacion` - Campos de documentos

**Julio 2025 - Features de Usuario:**
- ✅ `20250702211521_add_favorite_field` - Campo favorito
- ✅ `20250702211750_add_assessment_url` - URL de assessment
- ✅ `20250703000933_add_en_evaluacion_cliente_status` - Estado evaluación cliente
- ✅ `20250713201516_add_preliminary_interview_fields` - Entrevista preliminar
- ✅ `20250714210312_add_inactive_status` - Estado inactivo
- ✅ `20250714222020_add_bitacora_classification_events` - Eventos clasificación
- ✅ `20250715124538_add_preferencia_entrevista` - Preferencia entrevista
- ✅ `20250717202301_add_interview_states` - Estados de entrevista

**Agosto 2025 - Seguridad:**
- ✅ `20250811123433_added_password_reset` - Reset de contraseña
- ✅ `20250829100319_add_email_logs_table` - Logs de email

**Septiembre 2025 - Mejoras de Contratación:**
- ✅ `20250902095530_add_contrato_final_url_to_usuario` - URL contrato final
- ✅ `20250902100008_move_contrato_final_url_to_proceso_contratacion` - Mover campo
- ✅ `20250905033536_add_user_bank_fields` - Campos bancarios
- ✅ `20250919194807_add_contract_webhook_logs` - Logs de webhooks
- ✅ `20250920154047_add_s3_cleanup_email_type` - Tipo email S3 cleanup
- ✅ `20250920175915_add_s3_cleanup_backup_table` - Tabla backup S3
- ✅ `20250921164421_add_acepta_politica_datos_field` - Aceptación política
- ✅ `20250925170034_add_employee_credentials_email_type` - Email credenciales
- ✅ `20250926121614_add_visible_to_client_field` - Visibilidad cliente

**Octubre 2025 - Tracking Proveedor:**
- ✅ `20251020093154_add_provider_tracking_fields` - Campos tracking
- ✅ `20251020094103_add_resend_provider_history` - Historial reenvíos
- ✅ `20251020094514_add_historial_envio_proveedor` - Historial envíos

**Noviembre 2025 - Multi-Empresa y Entrevistas:**
- ✅ `20251104035037_add_roles_array_to_usuario` - Array de roles
- ✅ `20251104042000_backfill_roles_from_rol` - Migración de datos roles
- ✅ `20251104163547_allow_null_company_responsible` - Responsable nullable
- ✅ `20251105202947_multi_company_support_add_only` - Soporte multi-empresa
- ✅ `20251110204631_add_disponibilidad_entrevista_field_postulacion` - Disponibilidad
- ✅ `20251112000000_drop_unique_empleadoempresa_usuarioid` - Drop constraint
- ✅ `20251121122215_add_multiple_disponibilidad_entrevista` - Múltiples horarios
- ✅ `20251123123000_add_fecha_entrevista_confirmada` - Fecha confirmada
- ✅ `20251125200654_added_sign_model` - Modelo de firma
- ✅ `20251126065715_added_templates_sign_model` - Templates de firma
- ✅ `20251130045307_esign_minimal` - ESIGN mínimo

**Diciembre 2025 - Últimas Mejoras:**
- ✅ `20251212124016_add_annexes_relation` - Relación anexos
- ✅ `20251215222720_add_interview_timezone_to_postulacion` - Zona horaria
- ✅ `20251230035147_added_payments_inboxs` - Payment Inboxes

### 10.3 Scripts de Pre-Deploy

**Ubicación:** `sql/predeploy/`

**Archivos:**
1. `001_archive_columns.sql` - Archivado de columnas legacy
2. `002_fix_duplicados_empleado_empresa.sql` - Fix duplicados
3. `003_create_unique_index.sql` - Creación de índices únicos
4. `004_drop_unique_usuario_responsable.sql` - Eliminación constraint

**Ejecución:**
```bash
npm run db:predeploy
```

### 10.4 Scripts de Migración de Datos

**Scripts Disponibles:**
- `batch-migrate-contracts.ts` - Migración masiva de contratos
- Genera reportes JSON y CSV
- Ejecutable con ts-node

```bash
npm run contracts:migrate
```

### 10.5 Estrategia de Migraciones

**Patrón Identificado:**
1. ✅ **Additive First:** Agregar campos opcionales (nullable)
2. ✅ **Data Migration:** Backfill de datos si necesario
3. ✅ **Remove Constraints:** Eliminar constraints antiguos después
4. ✅ **Deprecate:** Marcar campos como deprecated antes de eliminar

**Ejemplo - Multi-Role Migration:**
```
1. 20251104035037 - Agregar campo roles[] (default [])
2. 20251104042000 - Backfill: copiar rol → roles[]
3. (Futuro) - Deprecate campo rol
4. (Futuro) - Remove campo rol
```

---

## 11. DOCUMENTACIÓN TÉCNICA

### 11.1 Inventario de Documentación

El proyecto cuenta con **20+ archivos de documentación** en la carpeta `docs/`:

| Documento | Propósito | Estado |
|-----------|-----------|--------|
| **ADMIN_PASSWORD_RESET.md** | Reset de contraseñas por admin | ✅ Completo |
| **AWS_S3_FILE_SERVICE_GUIDE.md** | Guía de servicio S3 | ✅ Completo |
| **CONTRACT_CANCELLATION_SYSTEM.md** | Sistema de cancelación de contratos | ✅ Completo |
| **DB_BACKUP.md** | Procedimientos de backup | ✅ Completo |
| **DEBUG_GUIDE.md** | Guía de debugging | ✅ Completo |
| **documentacion-modelos.md** | Documentación de modelos | ✅ Completo |
| **DOCUMNETACION-MODELOS.md** | Duplicado (typo) | ⚠️ Duplicado |
| **EMAIL_LOGGING_SYSTEM.md** | Sistema de logging de emails | ✅ Completo |
| **ESIGN_MODULE_README.md** | Documentación módulo ESIGN | ✅ Completo |
| **FEATURE_FLAGS.md** | Sistema de feature flags | ✅ Completo |
| **IMPLEMENTATION_SUMMARY.md** | Resumen de implementaciones | ✅ Completo |
| **MIGRATIONS.md** | Guía de migraciones | ✅ Completo |
| **MONTHLY_SCRIPT_AUTOMATION.md** | Automatizaciones mensuales | ✅ Completo |
| **NOMBRE_COMPLETO_FIX.md** | Fix de nombre completo | ✅ Completo |
| **PRISMA_MIGRATIONS_RUNBOOK.md** | Runbook de migraciones Prisma | ✅ Completo |
| **README-cambios-pais-modalidad.md** | Cambios país/modalidad | ✅ Completo |
| **README_S3_CLEANUP_CONFLUENCE.md** | Documentación S3 cleanup | ✅ Completo |
| **S3_CLEANUP_DOCUMENTATION.md** | Documentación limpieza S3 | ✅ Completo |
| **S3_CLEANUP_SYSTEM.md** | Sistema de limpieza S3 | ✅ Completo |
| **SISTEMA_MONITOREO_IMPLEMENTADO.md** | Sistema de monitoreo | ✅ Completo |
| **SISTEMA_S3_CLEANUP_COMPLETO.md** | Sistema S3 cleanup completo | ✅ Completo |

### 11.2 README Principal

**Archivo:** `README.md` (1,561 líneas)

**Secciones:**
- Descripción general
- Stack tecnológico completo
- Modelos de datos con ejemplos Prisma
- Instrucciones de instalación
- Configuración de variables de entorno
- Scripts disponibles
- Guía de desarrollo
- Endpoints de API
- Troubleshooting

### 11.3 Swagger/OpenAPI

**Configuración:** `@nestjs/swagger 11.0.6`

**Acceso:** Probablemente en `/api/docs` o `/api/swagger`

**Features:**
- ✅ Documentación automática de endpoints
- ✅ Schemas de DTOs
- ✅ Ejemplos de requests/responses
- ✅ Testing interactivo

### 11.4 Documentación de Código

**TSDoc Comments:**
```typescript
/// Documentos de firma electrónica creados por el usuario (ESIGN)
signatureDocumentsCreated: SignatureDocument[]

/// @deprecated Campo en desuso. Se eliminará en una release futura.
contratoFechaLeido: DateTime?
```

---

## 12. CI/CD Y DEPLOYMENT

### 12.1 GitHub Actions

**Archivo:** `.github/workflows/deploy.yml`

**Configuración:**
```yaml
name: Deploy API Production

on:
  push:
    branches: [ master ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          port: ${{ secrets.PORT }}
          script: ./deploy_api.sh
```

**Trigger:** Push a rama `master`

**Proceso:**
1. Checkout del código
2. SSH al servidor de producción
3. Ejecución de script `deploy_api.sh`

### 12.2 Scripts de Deployment

**Script de Deploy (Inferido):**
```bash
# deploy_api.sh (no incluido en el repo)
# Probablemente contiene:

git pull origin master
npm install
npm run db:predeploy
npm run db:migrate
npm run build
pm2 restart andes-api
```

### 12.3 Scripts NPM Disponibles

```json
{
  "build": "nest build",
  "start": "nest start",
  "start:dev": "nest start --watch",
  "start:debug": "nest start --debug --watch",
  "start:prod": "node dist/main",
  
  "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
  "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
  
  "test": "jest",
  "test:watch": "jest --watch",
  "test:cov": "jest --coverage",
  "test:e2e": "jest --config ./test/jest-e2e.json",
  
  "db:predeploy": "psql \"$DATABASE_URL\" -v ON_ERROR_STOP=1 ...",
  "db:predeploy:node": "node ./scripts/run-predeploy.js",
  "db:migrate": "prisma migrate deploy",
  
  "contracts:migrate": "ts-node -P ./tsconfig.scripts.json ./scripts/batch-migrate-contracts.ts"
}
```

### 12.4 Ambientes

**Ambientes Detectados:**
1. **Development** (`localhost`)
2. **Test** (`test.andes-workforce.app.appwiseinnovations.com`)
3. **Production** (`andes-workforce.com`)
4. **Preview** (`preview.test.andes-workforce.com`)

**Variables de Entorno por Ambiente:**
```env
NODE_ENV=development|test|production
PORT=3000
DATABASE_URL=postgresql://...
JWT_SECRET=...
AWS_S3_BUCKET=...
```

### 12.5 Backups

**Archivos de Backup Detectados:**
```
backups/
├── andes-prod-20251113-043901.dump     (Producción)
├── andes-test-20251113-043826.dump     (Test)
└── test-db-20251121-123328.dump        (Test)
```

**Sistema de Backup:**
- ✅ Cron job automatizado (sábados 01:00 AM Argentina)
- ✅ Feature flag: `DB_BACKUP_ENABLED`
- ✅ Upload a S3
- ✅ Formato: `.dump` (pg_dump)

---

## 13. RECOMENDACIONES Y OBSERVACIONES

### 13.1 Fortalezas del Proyecto ✅

1. **Arquitectura Sólida**
   - ✅ Modularidad bien definida
   - ✅ Separación clara de responsabilidades
   - ✅ Uso correcto de patrones NestJS

2. **Documentación Extensa**
   - ✅ 20+ archivos de documentación
   - ✅ README de 1,561 líneas
   - ✅ Comentarios en código (TSDoc)

3. **Modelo de Datos Robusto**
   - ✅ 25+ modelos bien relacionados
   - ✅ Uso de UUIDs
   - ✅ Enums para type-safety
   - ✅ Auditoría completa (timestamps, actualizadoPor)

4. **Seguridad**
   - ✅ JWT + bcryptjs
   - ✅ Helmet para headers seguros
   - ✅ Rate limiting
   - ✅ Validación estricta de DTOs

5. **Migraciones Controladas**
   - ✅ 60+ migraciones ordenadas
   - ✅ Scripts de pre-deploy
   - ✅ Estrategia additive-first

6. **Feature Flags**
   - ✅ Rollout controlado de features
   - ✅ Rollback sin redeploy

7. **Automatización**
   - ✅ CI/CD con GitHub Actions
   - ✅ Cron jobs (cleanup, backups)
   - ✅ Scripts de migración de datos

### 13.2 Áreas de Mejora ⚠️

#### 13.2.1 Deuda Técnica

1. **Duplicación de Módulos**
   - ⚠️ `usuarios` y `users` coexisten
   - **Recomendación:** Consolidar en un solo módulo

2. **Dependencia Legacy**
   - ⚠️ `aws-sdk` v2 (EOL próximo)
   - **Recomendación:** Migrar a AWS SDK v3

3. **Campos Deprecated No Eliminados**
   - ⚠️ `contratoFechaLeido`, `destinatario` en EmailLog
   - **Recomendación:** Crear plan de eliminación

4. **Documentación Duplicada**
   - ⚠️ `documentacion-modelos.md` y `DOCUMNETACION-MODELOS.md` (typo)
   - **Recomendación:** Eliminar duplicado

#### 13.2.2 Testing

1. **Cobertura de Tests**
   - ⚠️ Solo se detectan archivos `.spec.ts` básicos
   - ⚠️ No se ve configuración de fixtures o mocks
   - **Recomendación:**
     - Aumentar cobertura a >80%
     - Agregar tests de integración
     - Implementar tests E2E para flows críticos

2. **Testing de Migraciones**
   - ⚠️ No se detectan tests para scripts de migración
   - **Recomendación:** Tests unitarios para scripts críticos

#### 13.2.3 Monitoreo y Observabilidad

1. **Logging Estructurado**
   - ⚠️ No se detecta uso de Winston o similar
   - **Recomendación:**
     - Implementar logging estructurado (Winston + JSON)
     - Integrar con servicio de logs (CloudWatch, LogDNA, etc.)

2. **Métricas y APM**
   - ⚠️ No se detecta integración con APM (New Relic, DataDog, etc.)
   - **Recomendación:**
     - Agregar métricas de performance
     - Monitoring de endpoints críticos
     - Alertas automáticas

3. **Health Checks**
   - ⚠️ No se ve endpoint `/health`
   - **Recomendación:**
     - Implementar health checks (DB, S3, Email)
     - Integrar con load balancer

#### 13.2.4 Performance

1. **Paginación**
   - ⚠️ No se ve implementación consistente de paginación
   - **Recomendación:**
     - Estandarizar paginación en todos los listados
     - Implementar cursor-based pagination para grandes datasets

2. **Caching**
   - ⚠️ No se detecta estrategia de caching
   - **Recomendación:**
     - Implementar Redis para caché
     - Cachear queries frecuentes (listados de propuestas, empresas)

3. **Optimización de Queries**
   - ⚠️ Índices presentes pero revisar query plans
   - **Recomendación:**
     - Analizar N+1 queries
     - Usar Prisma `include` estratégicamente

#### 13.2.5 Seguridad Adicional

1. **Rotación de Secrets**
   - ⚠️ No se ve estrategia de rotación de JWT_SECRET
   - **Recomendación:**
     - Implementar rotación periódica de secrets
     - Usar AWS Secrets Manager o similar

2. **Auditoría de Permisos**
   - ⚠️ Sistema de roles implementado pero revisar granularidad
   - **Recomendación:**
     - Implementar RBAC más granular
     - Permisos a nivel de recurso (no solo rol)

3. **2FA**
   - ⚠️ No se detecta autenticación de dos factores
   - **Recomendación:**
     - Implementar 2FA opcional (TOTP)
     - Obligatorio para roles ADMIN

#### 13.2.6 Escalabilidad

1. **Queue System**
   - ⚠️ Emails y procesos pesados probablemente síncronos
   - **Recomendación:**
     - Implementar queue (Bull, BullMQ)
     - Procesar emails en background
     - Generación de PDFs en workers

2. **Microservicios**
   - ⚠️ Monolito en crecimiento
   - **Recomendación:**
     - Evaluar extracción de módulos grandes (ESIGN, Files)
     - Preparar para arquitectura de microservicios

### 13.3 Prioridades Sugeridas

#### Corto Plazo (1-2 meses)

1. 🔴 **Aumentar cobertura de tests** (>80%)
2. 🔴 **Implementar health checks**
3. 🟡 **Consolidar módulos usuarios/users**
4. 🟡 **Implementar paginación consistente**
5. 🟢 **Eliminar documentación duplicada**

#### Mediano Plazo (3-6 meses)

1. 🔴 **Migrar a AWS SDK v3**
2. 🔴 **Implementar sistema de queues**
3. 🟡 **Agregar logging estructurado**
4. 🟡 **Implementar caching con Redis**
5. 🟢 **Eliminar campos deprecated**

#### Largo Plazo (6-12 meses)

1. 🔴 **Integrar APM y monitoring**
2. 🟡 **Evaluar arquitectura de microservicios**
3. 🟡 **Implementar 2FA**
4. 🟢 **RBAC granular**

### 13.4 Observaciones Finales

**Estado General:** 🟢 **BUENO**

El proyecto API-ANDES es un sistema backend **maduro y bien estructurado** con:
- Arquitectura sólida basada en NestJS 11
- Modelo de datos complejo y bien diseñado
- Documentación extensa
- Sistema de migraciones robusto
- Seguridad básica implementada
- CI/CD automatizado

**Puntos Destacados:**
- ✅ Feature flags para rollout seguro
- ✅ Módulo ESIGN completo y moderno
- ✅ Sistema de auditoría completo
- ✅ Gestión de entrevistas con zonas horarias
- ✅ Multi-role support
- ✅ Payment Inboxes reciente (Dic 2025)

**Áreas de Atención:**
- ⚠️ Mejorar testing y coverage
- ⚠️ Implementar observabilidad completa
- ⚠️ Considerar queue system para procesos pesados
- ⚠️ Revisar y consolidar módulos duplicados

**Recomendación Final:**
El proyecto está en **condiciones de producción** pero se beneficiaría significativamente de las mejoras sugeridas en testing, monitoreo y escalabilidad para soportar crecimiento futuro.

---

## 14. APÉNDICES

### 14.1 Glosario de Términos

| Término | Definición |
|---------|-----------|
| **Propuesta** | Oferta laboral creada por un empleador |
| **Postulación** | Aplicación de un candidato a una propuesta |
| **ProcesoContratacion** | Flujo post-aceptación hasta firma de contrato |
| **SignWell** | Servicio externo de firma electrónica (legacy) |
| **ESIGN** | Módulo interno de firma electrónica (nuevo) |
| **Bitácora** | Sistema de auditoría de eventos |
| **ClasificacionGlobal** | Estado del candidato (ACTIVE, BLACKLIST, etc.) |
| **Payment Inbox** | Factura/invoice generado para pago mensual |

### 14.2 Acrónimos

| Acrónimo | Significado |
|----------|-------------|
| **JWT** | JSON Web Token |
| **DTO** | Data Transfer Object |
| **ORM** | Object-Relational Mapping |
| **S3** | Simple Storage Service (AWS) |
| **UUID** | Universally Unique Identifier |
| **RBAC** | Role-Based Access Control |
| **2FA** | Two-Factor Authentication |
| **APM** | Application Performance Monitoring |
| **CI/CD** | Continuous Integration/Continuous Deployment |

### 14.3 Contactos y Recursos

**Repositorio:** (Privado - ubicación local)

**Documentación Técnica:** `./docs/`

**Swagger UI:** `/api/docs` (inferido)

**Ambiente de Test:** `https://test.andes-workforce.app.appwiseinnovations.com`

**Ambiente de Producción:** `https://andes-workforce.com`

---

## 📝 NOTAS FINALES

Este análisis fue generado automáticamente basado en:
- Estructura de archivos del proyecto
- package.json y dependencias
- Esquema de Prisma (schema.prisma)
- Código fuente de módulos principales
- Documentación existente
- Historial de migraciones

**Última Actualización:** 22 de Enero de 2026

**Versión del Análisis:** 1.0

**Generado por:** Sistema de Análisis Automatizado

---

*Este documento es confidencial y contiene información sensible sobre la arquitectura del sistema API-ANDES. Distribución restringida.*
