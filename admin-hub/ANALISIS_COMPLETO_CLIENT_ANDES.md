# Análisis Completo del Proyecto CLIENT-ANDES

**Fecha de Análisis:** 29 de Enero, 2026  
**Versión del Proyecto:** 0.1.0  
**Framework Principal:** Next.js 16.1.0 (App Router)

---

## Tabla de Contenidos

1. [Descripción General](#descripción-general)
2. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
3. [Stack Tecnológico](#stack-tecnológico)
4. [Estructura de Carpetas Detallada](#estructura-de-carpetas-detallada)
5. [Sistema de Autenticación y Autorización](#sistema-de-autenticación-y-autorización)
6. [Flujos Principales de la Aplicación](#flujos-principales-de-la-aplicación)
7. [Componentes Principales](#componentes-principales)
8. [Gestión de Estado](#gestión-de-estado)
9. [Servicios y APIs](#servicios-y-apis)
10. [Módulos Funcionales](#módulos-funcionales)
11. [Routing y Middleware](#routing-y-middleware)
12. [Conclusiones y Recomendaciones](#conclusiones-y-recomendaciones)

---

## Descripción General

**Andes Client** es una plataforma web de gestión de recursos humanos (HRM) desarrollada con Next.js 16 que conecta candidatos con oportunidades laborales en América Latina. La aplicación soporta múltiples roles de usuario (Candidatos, Empresas, Administradores) y proporciona funcionalidades completas para:

- **Candidatos:** Creación de perfiles completos, postulación a ofertas laborales, gestión de aplicaciones y contratos
- **Empresas:** Publicación de ofertas, revisión de candidatos, gestión de empleados y procesos de contratación
- **Administradores:** Supervisión completa del sistema, gestión de usuarios, ofertas, plantillas de email y firma electrónica

---

## Arquitectura del Proyecto

### Patrón Arquitectónico

El proyecto sigue una **arquitectura basada en Next.js App Router** con los siguientes principios:

1. **Server-Side First:** Uso extensivo de Server Components y Server Actions
2. **Client Components Selectivos:** Solo para interactividad y estado del cliente
3. **API Routes:** Para endpoints de autenticación y operaciones específicas
4. **Middleware:** Para protección de rutas y manejo de autenticación
5. **Zustand para Estado Global:** Manejo del estado de autenticación y notificaciones

### Capas de la Aplicación

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Pages, Components, UI Elements)       │
├─────────────────────────────────────────┤
│         Business Logic Layer            │
│  (Server Actions, Hooks, Contexts)      │
├─────────────────────────────────────────┤
│         Data Access Layer               │
│  (Axios Services, API Clients)          │
├─────────────────────────────────────────┤
│         External Services               │
│  (Backend API, Authentication)          │
└─────────────────────────────────────────┘
```

---

## Stack Tecnológico

### Frontend Core

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Next.js** | 16.1.0 | Framework principal (App Router) |
| **React** | 19.2.3 | Biblioteca UI |
| **TypeScript** | 5.x | Lenguaje tipado |
| **Tailwind CSS** | 4.x | Framework CSS |

### Bibliotecas de UI y UX

| Biblioteca | Versión | Uso |
|------------|---------|-----|
| **Lucide React** | 0.477.0 | Sistema de iconos |
| **Radix UI** | 1.1.9 | Componentes accesibles (Tabs) |
| **React Hook Form** | 7.54.2 | Gestión de formularios |
| **Zod** | 3.24.2 | Validación de esquemas |
| **Driver.js** | 1.4.0 | Tours guiados de usuario |

### Gestión de Documentos

| Biblioteca | Versión | Funcionalidad |
|------------|---------|---------------|
| **React PDF** | 9.2.1 | Visualización de PDFs |
| **@react-pdf/renderer** | 4.3.0 | Generación de PDFs |
| **pdfjs-dist** | 5.4.449 | Motor PDF de Mozilla |
| **React Quill** | 2.0.0 | Editor de texto enriquecido |
| **Slate** | 0.112.0 | Framework de edición |

### Estado y Comunicación

| Biblioteca | Versión | Uso |
|------------|---------|-----|
| **Zustand** | 5.0.3 | Estado global |
| **Axios** | 1.8.4 | Cliente HTTP |
| **React Email** | - | Plantillas de email |
| **Resend** | 4.1.2 | Envío de correos |
| **Nodemailer** | 6.10.0 | Sistema de email |

### Utilidades

| Biblioteca | Versión | Funcionalidad |
|------------|---------|---------------|
| **Crypto-js** | 4.2.0 | Encriptación |
| **DOMPurify** | 3.2.4 | Sanitización HTML |
| **CLSX** | 2.1.1 | Utilidad de clases CSS |
| **Tailwind Merge** | 3.2.0 | Merge de clases Tailwind |
| **XLSX** | 0.18.5 | Manejo de archivos Excel |
| **Signature Pad** | 5.1.3 | Captura de firmas |

### Autenticación

| Biblioteca | Versión | Uso |
|------------|---------|-----|
| **@azure/msal-node** | 3.3.0 | Autenticación Microsoft |

---

## Estructura de Carpetas Detallada

### Directorio Raíz

```
CLIENT-ANDES/
├── .github/workflows/          # CI/CD con GitHub Actions
│   └── deploy.yml              # Pipeline de despliegue
├── .next/                      # Build de Next.js (generado)
├── .vscode/                    # Configuración de VS Code
│   ├── extensions.json
│   ├── settings.json
│   └── tasks.json
├── audit/                      # Auditorías y reportes
├── docs/                       # Documentación técnica
│   ├── CONFLUENCE_DOCUMENTATION.md
│   ├── CONTRACT_CANCELLATION_IMPLEMENTATION.md
│   ├── CONTRACTS_BULK_IMPORT.md
│   ├── CONTRACTS_RENDER_MAP.md
│   ├── INVOICE_ERROR_400_FIX.md
│   ├── INVOICE_FIX_SUMMARY.md
│   └── [más documentación...]
├── public/                     # Recursos públicos
│   ├── images/                 # Imágenes estáticas
│   ├── manifest.json           # PWA manifest
│   ├── pdf.worker.min.js       # Worker de PDF.js
│   └── appwise-banner.js       # Banner de AppWise
├── scripts/                    # Scripts de utilidad
│   └── copy-pdf-worker.mjs     # Copia worker de PDF
└── src/                        # Código fuente principal
```

### Directorio src/app (App Router)

```
src/app/
├── account/                    # Gestión de cuenta de usuario
│   ├── actions/
│   │   └── account.actions.ts
│   └── page.tsx
│
├── admin/                      # Área de administradores
│   ├── dashboard/              # Dashboard principal
│   │   ├── account/            # Cuenta de admin
│   │   ├── actions/            # Server Actions
│   │   ├── candidates/         # Gestión de candidatos
│   │   ├── clients/            # Gestión de clientes
│   │   ├── components/         # Componentes del dashboard
│   │   ├── context/            # Contextos de admin
│   │   ├── contracts/          # Gestión de contratos
│   │   ├── emails/             # Gestión de emails
│   │   ├── esign/              # Firma electrónica
│   │   ├── notifications/      # Notificaciones
│   │   ├── offers/             # Gestión de ofertas
│   │   ├── postulants/         # Postulantes
│   │   ├── process/            # Procesos de reclutamiento
│   │   ├── save-offers/        # Ofertas guardadas
│   │   ├── team-members/       # Miembros del equipo
│   │   ├── templates/          # Plantillas
│   │   ├── types/              # Tipos TypeScript
│   │   ├── layout.tsx
│   │   └── page.tsx
│   │
│   ├── applicants/             # Área de aplicantes (legacy)
│   ├── login/                  # Login de admin
│   └── superAdmin/             # Super administrador
│       ├── payments/           # Gestión de pagos
│       ├── users/              # Gestión de usuarios
│       ├── users-roles/        # Roles de usuarios
│       ├── layout.tsx
│       └── page.tsx
│
├── api/                        # API Routes de Next.js
│   ├── auth/                   # Endpoints de autenticación
│   │   ├── login/
│   │   ├── logout/
│   │   └── register/
│   ├── health/                 # Health check
│   └── [otros endpoints]/
│
├── applications/               # Aplicaciones del candidato
│   ├── actions/
│   │   └── applications.actions.ts
│   └── page.tsx
│
├── auth/                       # Páginas de autenticación
│   ├── fargot-password/        # Recuperar contraseña
│   ├── forced-logout/          # Logout forzado
│   ├── login/                  # Login
│   │   ├── components/
│   │   │   └── LoginForm.tsx
│   │   ├── actions/
│   │   │   └── login.action.ts
│   │   ├── select-role/        # Selección de rol
│   │   │   └── page.tsx
│   │   └── page.tsx
│   ├── register/               # Registro
│   │   ├── components/
│   │   │   └── RegisterForm.tsx
│   │   └── page.tsx
│   └── reset-password/         # Resetear contraseña
│
├── bonifications/              # Sistema de bonificaciones
│   └── page.tsx
│
├── companies/                  # Área de empresas
│   ├── account/                # Cuenta de empresa
│   │   ├── actions/
│   │   └── page.tsx
│   ├── components/             # Componentes de empresas
│   │   ├── HeaderDashboard.tsx
│   │   └── TabsNavigation.tsx
│   ├── context/                # Contextos
│   │   └── CompaniesContext.tsx
│   ├── dashboard/              # Dashboard de empresa
│   │   ├── actions/
│   │   │   ├── applicants.actions.ts
│   │   │   ├── employee.actions.ts
│   │   │   ├── interview.actions.ts
│   │   │   ├── offers.actions.ts
│   │   │   └── offers-with-accepted.actions.ts
│   │   ├── components/
│   │   │   ├── ClientApplicantsModal.tsx
│   │   │   ├── EditEmployeeModal.tsx
│   │   │   ├── EmployeesTable.tsx
│   │   │   └── TableSkeleton.tsx
│   │   ├── employees/          # Gestión de empleados
│   │   │   └── page.tsx
│   │   ├── listEmployees/      # Lista de empleados
│   │   │   └── page.tsx
│   │   ├── offers/             # Ofertas de la empresa
│   │   │   └── page.tsx
│   │   ├── team-members/       # Miembros del equipo
│   │   │   └── page.tsx
│   │   └── page.tsx
│   └── layout.tsx
│
├── components/                 # Componentes globales de la app
│   ├── ui/                     # Componentes UI reutilizables
│   │   ├── date-picker/
│   │   │   └── date-picker.tsx
│   │   ├── application-status-badge.tsx
│   │   ├── application-warning-modal.tsx
│   │   ├── Logo.tsx
│   │   ├── tabs.tsx
│   │   └── Toast.tsx
│   ├── ConfirmDeleteModal.tsx
│   ├── ConfirmPauseModal.tsx
│   ├── EditOfferModal.tsx
│   ├── Footer.tsx
│   ├── Logo.tsx
│   ├── Navbar.tsx
│   ├── NotificationsBell.tsx
│   ├── NotificationsSidebar.tsx
│   ├── SimpleHeader.tsx
│   └── ViewOfferModal.tsx
│
├── currentApplication/         # Aplicación actual del usuario
│   ├── actions/
│   │   ├── current-contract.actions.ts
│   │   └── invoices.actions.ts
│   ├── components/
│   │   └── DocumentTemplates.tsx
│   └── page.tsx
│
├── esign/                      # Sistema de firma electrónica
│   ├── provider/
│   │   └── [token]/
│   │       └── page.tsx
│   └── public/
│       └── sign/
│           ├── [token]/
│           │   └── page.tsx
│           └── components/
│               └── PdfSignViewer.tsx
│
├── health/                     # Health check page
│   └── page.tsx
│
├── pages/                      # Páginas públicas y de contenido
│   ├── about/                  # Acerca de
│   ├── contact/                # Contacto
│   │   ├── components/
│   │   │   └── ContactForm.tsx
│   │   └── page.tsx
│   ├── home/                   # Página de inicio
│   │   ├── components/
│   │   │   ├── AboutSection.tsx
│   │   │   ├── HeroSection.tsx
│   │   │   ├── PartnersSection.tsx
│   │   │   ├── PersonnelTypes.tsx
│   │   │   ├── ServicesSection.tsx
│   │   │   └── TestimonialsSection.tsx
│   │   └── page.tsx
│   ├── offers/                 # Ofertas públicas
│   │   ├── actions/
│   │   │   ├── jobs.actions.ts
│   │   │   └── user-status.actions.ts
│   │   ├── components/
│   │   │   ├── FilterModal.tsx
│   │   │   ├── JobFilters.tsx
│   │   │   ├── OfferDetailGuard.tsx
│   │   │   └── OffersAccessGuard.tsx
│   │   └── page.tsx
│   ├── privacy-policy/         # Política de privacidad
│   ├── services/               # Servicios
│   └── team/                   # Equipo
│
├── politica-datos/             # Política de datos
│   └── page.tsx
│
├── profile/                    # Perfil de usuario
│   ├── actions/
│   │   ├── bank-info.actions.ts
│   │   ├── education.actions.ts
│   │   ├── experience.actions.ts
│   │   ├── formulario.actions.ts
│   │   └── profile.actions.ts
│   ├── components/
│   │   ├── ViewContactoModal.tsx
│   │   ├── ViewFormularioModal.tsx
│   │   ├── ViewPCRequirementsModal.tsx
│   │   ├── ViewSkillsModal.tsx
│   │   └── ViewVideoModal.tsx
│   ├── context/
│   │   └── ProfileContext.tsx
│   ├── layout.tsx
│   └── page.tsx
│
├── types/                      # Tipos TypeScript globales
├── globals.css                 # Estilos globales
├── layout.tsx                  # Layout principal
├── logo.png                    # Logo
├── not-found.tsx               # Página 404
└── page.tsx                    # Página de inicio (redirect)
```

### Directorio src/ (otros componentes)

```
src/
├── assets/                     # Assets estáticos
│
├── components/                 # Componentes reutilizables
│   ├── icons/                  # Iconos personalizados
│   │   ├── Add.tsx
│   │   ├── Dump.tsx
│   │   ├── Edit.tsx
│   │   └── UploadFile.tsx
│   ├── ui/                     # Componentes UI base
│   │   ├── application-status-badge.tsx
│   │   ├── application-warning-modal.tsx
│   │   ├── Logo.tsx
│   │   ├── tabs.tsx
│   │   └── Toast.tsx
│   └── InterviewDateTimePicker.tsx
│
├── features/                   # Características modulares
│   └── esign/                  # Feature de firma electrónica
│       └── components/
│           ├── EsignFieldCanvas.tsx
│           ├── RecipientProgressBar.tsx
│           └── SignPage.tsx
│
├── hooks/                      # Custom Hooks
│   ├── use-application-history.ts
│   ├── useOutsideClick.ts
│   ├── useRouteExclusion.ts
│   └── useScrollShadow.ts
│
├── interfaces/                 # Interfaces TypeScript
│   └── api.interface.ts        # Interfaces de API
│
├── lib/                        # Utilidades y helpers
│
├── services/                   # Servicios de API
│   ├── axios.client.ts         # Cliente Axios (client-side)
│   ├── axios.instance.ts       # Instancia base de Axios
│   └── axios.server.ts         # Cliente Axios (server-side)
│
├── store/                      # Stores de Zustand
│   ├── app-notifications.store.ts
│   ├── auth.store.ts
│   └── notifications.store.ts
│
├── types/                      # Tipos TypeScript compartidos
│
└── middleware.ts               # Middleware de Next.js
```

---

## Sistema de Autenticación y Autorización

### Roles de Usuario

El sistema implementa **6 roles principales** con permisos diferenciados:

#### 1. **CANDIDATO** (Candidate)
- **Permisos:**
  - Crear y editar perfil personal
  - Postularse a ofertas laborales
  - Ver y gestionar aplicaciones
  - Acceder a contratos e invoices propias
- **Rutas de acceso:**
  - `/profile` - Perfil personal
  - `/pages/offers` - Ver ofertas
  - `/applications` - Mis aplicaciones
  - `/currentApplication` - Aplicación actual/contrato
  - `/account` - Configuración de cuenta

#### 2. **EMPRESA** (Company Owner)
- **Permisos:**
  - Publicar y gestionar ofertas laborales
  - Revisar aplicaciones y candidatos
  - Gestionar empleados de la empresa
  - Ver métricas y dashboard empresarial
- **Rutas de acceso:**
  - `/companies/dashboard` - Dashboard principal
  - `/companies/dashboard/offers` - Gestión de ofertas
  - `/companies/dashboard/employees` - Gestión de empleados
  - `/companies/account` - Configuración de empresa

#### 3. **EMPLEADO_EMPRESA** (Company Employee)
- **Permisos:**
  - Ver ofertas de la empresa
  - Revisar candidatos (según permisos)
  - Colaborar en procesos de selección
- **Rutas de acceso:**
  - `/companies/dashboard` - Dashboard
  - `/companies/dashboard/offers` - Ver ofertas
  - Acceso limitado según configuración

#### 4. **ADMIN** (Administrator / Super Admin)
- **Permisos:**
  - Acceso completo al sistema
  - Gestión de usuarios y roles
  - Gestión de empresas y asociaciones
  - Configuración global del sistema
  - Acceso a métricas y reportes avanzados
- **Rutas de acceso:**
  - `/admin/dashboard` - Dashboard administrativo
  - `/admin/superAdmin` - Panel de super admin
  - `/admin/superAdmin/users` - Gestión de usuarios
  - `/admin/superAdmin/users-roles` - Gestión de roles
  - Todas las rutas de admin

#### 5. **EMPLEADO_ADMIN** (Admin Employee)
- **Permisos:**
  - Gestión de candidatos y ofertas
  - Gestión de procesos de reclutamiento
  - Acceso a plantillas y notificaciones
  - Sin acceso a configuración de roles/usuarios
- **Rutas de acceso:**
  - `/admin/dashboard` - Dashboard
  - `/admin/dashboard/candidates` - Candidatos
  - `/admin/dashboard/offers` - Ofertas
  - `/admin/dashboard/process` - Procesos

#### 6. **ADMIN_RECLUTAMIENTO** (Recruitment Admin)
- **Permisos:**
  - Enfocado en procesos de reclutamiento
  - Gestión de candidatos y postulaciones
  - Coordinación de entrevistas
  - Acceso limitado a configuración
- **Rutas de acceso:**
  - `/admin/dashboard` - Dashboard
  - `/admin/dashboard/candidates` - Candidatos
  - `/admin/dashboard/postulants` - Postulantes
  - Rutas específicas de reclutamiento

### Flujo de Autenticación

#### Diagrama de Flujo General

```
┌─────────────────┐
│  Usuario llega  │
│  a la app       │
└────────┬────────┘
         │
         v
┌─────────────────┐
│ Middleware      │◄────── Verifica cookies
│ verifica token  │         auth_token
└────────┬────────┘         user_info
         │
    ┌────┴────┐
    │         │
No  │         │  Sí
    v         v
┌────────┐  ┌──────────────┐
│Redirect│  │ Determina    │
│ /login │  │ rol y rutas  │
└────────┘  └──────┬───────┘
                   │
            ┌──────┴──────┐
            │             │
         Admin         Empresa
            │             │
            v             v
    ┌──────────────┐  ┌──────────────┐
    │/admin/       │  │/companies/   │
    │dashboard     │  │dashboard     │
    └──────────────┘  └──────────────┘
```

#### Proceso de Login Detallado

1. **Inicio de sesión** (`/auth/login`)
   - Usuario ingresa correo y contraseña
   - Se envía a `/api/auth/login` o login action

2. **Verificación de credenciales**
   - Backend valida usuario y contraseña
   - Genera JWT token si es válido
   - Retorna información del usuario y sus roles

3. **Selección de rol** (`/auth/login/select-role`)
   - Si usuario tiene múltiples roles, se muestra selector
   - Usuario elige el rol con el que desea trabajar
   - Si el rol es `EMPRESA` o `EMPLEADO_EMPRESA`, se requiere selección de empresa

4. **Selección de empresa** (si aplica)
   - Usuario con rol de empresa ve lista de empresas asociadas
   - Selecciona la empresa con la que trabajará en la sesión
   - Se guarda `active_company_id` en cookie

5. **Finalización de sesión**
   - Se guardan cookies:
     - `auth_token`: JWT token
     - `user_info`: Información del usuario (nombre, rol, etc.)
     - `active_company_id`: ID de empresa activa (solo empresas)
   - Se actualiza Zustand store
   - Redirect según rol:
     - Admin → `/admin/dashboard`
     - Empresa → `/companies/dashboard`
     - Candidato con perfil incompleto → `/profile`
     - Candidato → `/pages/offers`

### Protección de Rutas (Middleware)

El archivo `src/middleware.ts` implementa la protección de rutas:

#### Rutas Públicas
```typescript
const publicRoutes = [
  "/",
  "/api/auth/logout",
  "/api/auth/login/with-company",
  "/api/health",
  "/health",
  "/esign", // Firma electrónica pública
];
```

#### Rutas Protegidas por Rol

**Candidatos:**
```typescript
const protectedRoutes = [
  "/profile",
  "/applications",
  "/account",
  "/pages/offers/apply",
  "/user",
];
```

**Empresas:**
```typescript
const companyRoutes = [
  "/companies/dashboard",
  "/companies/dashboard/offers",
  "/companies/dashboard/employees",
  "/companies/dashboard/employees/new",
  "/companies/account",
];
```

**Administradores:**
```typescript
const adminRoutes = [
  "/admin/dashboard",
  "/admin/users",
  "/admin/offers",
];
```

**Super Administradores:**
```typescript
const superAdminRoutes = [
  "/admin/superAdmin",
];
```

#### Lógica de Redirección del Middleware

```typescript
// 1. Usuario autenticado intenta acceder a login → Redirect a dashboard
if (isAuthenticated && authRoutes.includes(pathname)) {
  if (isAdmin) return redirect("/admin/dashboard");
  if (isCompany) return redirect("/companies/dashboard");
  return redirect("/pages/offers");
}

// 2. Empresa intenta acceder a rutas no empresariales → Redirect
if (isCompany && !companyRoutes.includes(pathname)) {
  return redirect("/companies/dashboard");
}

// 3. Usuario no autenticado intenta acceder a ruta protegida → Login
if (!isAuthenticated && protectedRoutes.includes(pathname)) {
  return redirect("/auth/login");
}

// 4. Usuario sin permisos de admin intenta acceder → Forbidden
if (!isAdmin && adminRoutes.includes(pathname)) {
  return redirect("/auth/forced-logout?reason=unauthorized");
}
```

### Gestión de Estado de Autenticación

#### Zustand Store (`auth.store.ts`)

```typescript
interface User {
  id: string;
  nombre: string;
  apellido: string;
  correo: string;
  rol: string;
  token: string;
  empresaId?: string;
  empleadoEmpresa?: EmpleadoEmpresa;
}

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  token: string | null;
  
  setUser: (user: User | null) => void;
  setAuthenticated: (status: boolean) => void;
  setLoading: (status: boolean) => void;
  logout: () => void;
  setToken: (token: string) => void;
}
```

**Características:**
- **Persistencia:** Usa `zustand/persist` para guardar en localStorage
- **Sincronización con cookies:** Se sincroniza con cookies del servidor
- **Hydration segura:** Maneja correctamente la hidratación en SSR

#### Cookies del Servidor

1. **`auth_token`**
   - Contiene el JWT token
   - HttpOnly: Sí (seguridad)
   - SameSite: Strict
   - Max-Age: 7 días

2. **`user_info`**
   - Información básica del usuario (JSON)
   - Incluye: nombre, apellido, correo, rol
   - Accesible desde cliente
   - Max-Age: 7 días

3. **`active_company_id`**
   - ID de la empresa activa (solo para roles empresariales)
   - Max-Age: 7 días

---

## Flujos Principales de la Aplicación

### 1. Flujo de Registro de Candidato

```
┌──────────────┐
│   Usuario    │
│  visita /    │
└──────┬───────┘
       │
       v
┌──────────────────┐
│ Click "Register" │
└──────┬───────────┘
       │
       v
┌─────────────────────┐
│ /auth/register      │
│ Formulario:         │
│ - Nombre            │
│ - Apellido          │
│ - Correo            │
│ - Contraseña        │
│ - Confirmar         │
└──────┬──────────────┘
       │
       v
┌──────────────────────┐
│ Validación con Zod   │
│ React Hook Form      │
└──────┬───────────────┘
       │
       v
┌──────────────────────────┐
│ POST /api/auth/register  │
│ Backend crea usuario     │
│ Rol: CANDIDATO          │
└──────┬───────────────────┘
       │
       v
┌──────────────────────┐
│ Success:             │
│ - Crear cookies      │
│ - Actualizar store   │
│ - Redirect /profile  │
└──────┬───────────────┘
       │
       v
┌──────────────────────┐
│ /profile             │
│ Completar perfil:    │
│ - Info personal      │
│ - Educación          │
│ - Experiencia        │
│ - Skills             │
│ - Video intro        │
│ - Bank info          │
└──────────────────────┘
```

**Server Actions Involucradas:**
- `src/app/auth/register/actions/register.action.ts`
- `src/app/profile/actions/profile.actions.ts`
- `src/app/profile/actions/education.actions.ts`
- `src/app/profile/actions/experience.actions.ts`

### 2. Flujo de Postulación a Oferta

```
┌────────────────┐
│  Candidato     │
│  autenticado   │
└────────┬───────┘
         │
         v
┌─────────────────────┐
│ /pages/offers       │
│ - Ver ofertas       │
│ - Filtrar           │
│ - Buscar            │
└────────┬────────────┘
         │
         v
┌─────────────────────┐
│ Click en oferta     │
│ Ver detalles        │
└────────┬────────────┘
         │
         v
┌─────────────────────────┐
│ Verificar estado perfil │
│ - Completo?             │
│ - Ya aplicado?          │
└────────┬────────────────┘
         │
    ┌────┴─────┐
    │          │
 No │          │ Sí
    v          v
┌────────┐  ┌──────────────────┐
│Redirect│  │ Botón "Apply"    │
│/profile│  │ disponible       │
└────────┘  └────────┬─────────┘
                     │
                     v
            ┌────────────────────┐
            │ Click "Apply"      │
            │ Confirmar          │
            └────────┬───────────┘
                     │
                     v
            ┌─────────────────────────┐
            │ POST /applications      │
            │ Crear aplicación        │
            │ Estado: PENDING         │
            └────────┬────────────────┘
                     │
                     v
            ┌─────────────────────┐
            │ Notificación:       │
            │ "Aplicación enviada"│
            │ Redirect /apps      │
            └─────────────────────┘
```

**Server Actions Involucradas:**
- `src/app/pages/offers/actions/jobs.actions.ts`
- `src/app/pages/offers/actions/user-status.actions.ts`
- `src/app/applications/actions/applications.actions.ts`

### 3. Flujo de Gestión de Candidatos (Empresa)

```
┌───────────────────┐
│  Usuario Empresa  │
│  login            │
└────────┬──────────┘
         │
         v
┌─────────────────────────┐
│ /auth/login/select-role │
│ Elegir: EMPRESA         │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Seleccionar empresa     │
│ (si tiene múltiples)    │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ /companies/dashboard    │
│ - Ver métricas          │
│ - Ofertas activas       │
│ - Empleados             │
│ - Aplicaciones nuevas   │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ /companies/dashboard/   │
│ offers                  │
│ - Ver ofertas           │
│ - Crear nueva           │
│ - Editar/Pausar         │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Click en oferta         │
│ Ver aplicantes          │
└────────┬────────────────┘
         │
         v
┌─────────────────────────────┐
│ ClientApplicantsModal       │
│ - Lista de candidatos       │
│ - Estado de cada uno        │
│ - Acciones:                 │
│   * Aprobar                 │
│   * Rechazar                │
│   * Agendar entrevista      │
│   * Ver perfil completo     │
└────────┬────────────────────┘
         │
         v
┌─────────────────────────┐
│ Click "Schedule         │
│ Interview"              │
└────────┬────────────────┘
         │
         v
┌─────────────────────────────┐
│ InterviewDateTimePicker     │
│ - Seleccionar fecha/hora    │
│ - Agregar notas             │
└────────┬────────────────────┘
         │
         v
┌─────────────────────────┐
│ Confirmar               │
│ POST interview          │
│ Notificar candidato     │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Estado actualizado      │
│ Email enviado           │
└─────────────────────────┘
```

**Server Actions Involucradas:**
- `src/app/companies/dashboard/actions/applicants.actions.ts`
- `src/app/companies/dashboard/actions/interview.actions.ts`
- `src/app/companies/dashboard/actions/offers.actions.ts`

### 4. Flujo de Gestión de Roles (Super Admin)

```
┌───────────────┐
│  Super Admin  │
│  login        │
└───────┬───────┘
        │
        v
┌────────────────────────┐
│ /admin/dashboard       │
└────────┬───────────────┘
        │
        v
┌─────────────────────────┐
│ /admin/superAdmin/      │
│ users-roles             │
│ - Buscar usuarios       │
└────────┬────────────────┘
        │
        v
┌──────────────────────────┐
│ Buscar por email         │
│ (REQUIRE_EMAIL = true)   │
└────────┬─────────────────┘
        │
        v
┌──────────────────────────┐
│ Lista de usuarios        │
│ mostrada con roles       │
└────────┬─────────────────┘
        │
        v
┌──────────────────────────┐
│ Click "Edit" usuario     │
└────────┬─────────────────┘
        │
        v
┌────────────────────────────────┐
│ Modo edición:                  │
│ - Checkboxes de roles          │
│ - Buscar empresa (si aplica)   │
│ - Asignar empresa              │
│ - Ver asociaciones actuales    │
└────────┬───────────────────────┘
        │
        v
┌─────────────────────────────────┐
│ Seleccionar roles:              │
│ ☑ ADMIN                         │
│ ☐ EMPLEADO_ADMIN                │
│ ☐ ADMIN_RECLUTAMIENTO           │
│ ☑ EMPLEADO_EMPRESA              │
│ ☐ CANDIDATO                     │
└────────┬────────────────────────┘
        │
        v
┌──────────────────────────────────┐
│ Si EMPLEADO_EMPRESA:             │
│ - Buscar empresa                 │
│ - Seleccionar de lista           │
│ - Asignar como empleado          │
└────────┬─────────────────────────┘
        │
        v
┌──────────────────────────────┐
│ Click "Save"                 │
│ POST update roles            │
│ POST assign company (si req) │
└────────┬─────────────────────┘
        │
        v
┌────────────────────────┐
│ Success notification   │
│ Refresh lista          │
└────────────────────────┘
```

**Server Actions Involucradas:**
- `src/app/admin/superAdmin/users-roles/actions/users-roles.actions.ts`
  - `searchUsuarios()`
  - `updateUsuarioRoles()`
  - `searchCompanies()`
  - `assignUsuarioToCompanyEmployee()`
  - `getUsuarioCompanyAssociation()`
  - `setCompanyResponsible()`
  - `clearCompanyResponsible()`

### 5. Flujo de Firma Electrónica (E-Sign)

```
┌─────────────────────┐
│  Admin crea         │
│  documento a firmar │
└────────┬────────────┘
         │
         v
┌──────────────────────────┐
│ /admin/dashboard/esign   │
│ - Subir PDF              │
│ - Definir firmantes      │
│ - Colocar campos firma   │
└────────┬─────────────────┘
         │
         v
┌──────────────────────────┐
│ POST create document     │
│ - Generar tokens únicos  │
│ - Enviar emails          │
└────────┬─────────────────┘
         │
         v
┌──────────────────────────┐
│ Firmante recibe email    │
│ con link único           │
└────────┬─────────────────┘
         │
         v
┌───────────────────────────┐
│ /esign/public/sign/       │
│ [token]                   │
│ - Ver documento           │
│ - Campos resaltados       │
└────────┬──────────────────┘
         │
         v
┌───────────────────────────┐
│ PdfSignViewer             │
│ - Mostrar PDF             │
│ - SignaturePad para firma │
│ - Campos de texto         │
└────────┬──────────────────┘
         │
         v
┌───────────────────────────┐
│ Firmante firma campos     │
│ - Firma manuscrita        │
│ - Iniciales               │
│ - Fecha (auto)            │
└────────┬──────────────────┘
         │
         v
┌───────────────────────────┐
│ Click "Submit"            │
│ POST signature            │
└────────┬──────────────────┘
         │
         v
┌────────────────────────────┐
│ Backend:                   │
│ - Validar firma            │
│ - Actualizar documento     │
│ - Marcar como firmado      │
│ - Notificar siguiente      │
└────────┬───────────────────┘
         │
         v
┌────────────────────────────┐
│ Si todos firmaron:         │
│ - Generar PDF final        │
│ - Notificar admin          │
│ - Archivar documento       │
└────────────────────────────┘
```

**Componentes Involucrados:**
- `src/features/esign/components/SignPage.tsx`
- `src/features/esign/components/EsignFieldCanvas.tsx`
- `src/features/esign/components/RecipientProgressBar.tsx`
- `src/app/esign/public/sign/components/PdfSignViewer.tsx`

### 6. Flujo de Gestión de Contratos (Candidato)

```
┌──────────────────┐
│  Candidato con   │
│  oferta aceptada │
└────────┬─────────┘
         │
         v
┌─────────────────────────┐
│ /currentApplication     │
│ - Ver contrato activo   │
│ - Documentos            │
│ - Invoices              │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Tabs:                   │
│ - Contract Info         │
│ - Documents             │
│ - Invoices              │
│ - Templates             │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Contract Info Tab:      │
│ - Empresa               │
│ - Posición              │
│ - Fecha inicio          │
│ - Salario               │
│ - Estado                │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Documents Tab:          │
│ - Contrato firmado      │
│ - NDA                   │
│ - Policies              │
│ - Download PDFs         │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Invoices Tab:           │
│ - Lista de invoices     │
│ - Estado: Paid/Pending  │
│ - Generar nueva         │
│ - Download              │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Click "Generate         │
│ Invoice"                │
└────────┬────────────────┘
         │
         v
┌─────────────────────────────┐
│ Formulario:                 │
│ - Periodo (mes/año)         │
│ - Horas trabajadas          │
│ - Rate (auto desde contrato)│
│ - Items adicionales         │
└────────┬────────────────────┘
         │
         v
┌─────────────────────────┐
│ Preview invoice PDF     │
│ - Ver antes de enviar   │
└────────┬────────────────┘
         │
         v
┌─────────────────────────┐
│ Confirm & Submit        │
│ POST invoice            │
└────────┬────────────────┘
         │
         v
┌──────────────────────────┐
│ Backend:                 │
│ - Crear invoice          │
│ - Generar PDF            │
│ - Notificar empresa      │
│ - Estado: PENDING        │
└────────┬─────────────────┘
         │
         v
┌──────────────────────────┐
│ Success notification     │
│ Invoice visible en lista │
└──────────────────────────┘
```

**Server Actions Involucradas:**
- `src/app/currentApplication/actions/current-contract.actions.ts`
- `src/app/currentApplication/actions/invoices.actions.ts`

---

## Componentes Principales

### Componentes de Layout

#### 1. **Navbar** (`src/app/components/Navbar.tsx`)

**Propósito:** Navegación principal de la aplicación con menús contextuales según el rol

**Características:**
- Responsive (desktop y móvil)
- Menú contextual por rol de usuario
- Sidebar móvil
- NotificationsBell integrado
- Dropdown de usuario con opciones
- Links dinámicos según permisos

**Estados:**
```typescript
- showUserMenu: boolean
- showMobileSidebar: boolean
- user: User | null (desde auth store)
```

**Menús por Rol:**

**Candidato:**
- Home
- Services
- Job Offers
- My Applications
- Profile
- Account
- Additional Incentives

**Empresa:**
- Company Panel (dashboard)
- Profile
- Account

**Admin/Super Admin:**
- Admin Dashboard
- Super Admin Panel (solo ADMIN)
- Profile
- Account

#### 2. **Footer** (`src/app/components/Footer.tsx`)

**Propósito:** Footer con información de la empresa y links útiles

**Secciones:**
- Logo y descripción
- Quick Links
- Contact Info
- Social Media
- Copyright

#### 3. **SimpleHeader** (`src/app/components/SimpleHeader.tsx`)

**Propósito:** Header simplificado para páginas de autenticación y páginas públicas sin sesión

### Componentes de UI Reutilizables

#### 1. **Toast** (`src/components/ui/Toast.tsx`)

**Propósito:** Sistema de notificaciones flotantes

**Tipos:**
- Success (verde)
- Error (rojo)
- Warning (amarillo)
- Info (azul)

**Características:**
- Auto-dismiss (configurable)
- Posición fija (top-right)
- Animaciones de entrada/salida
- Stack de múltiples notificaciones

**Integración con Zustand:**
```typescript
// notifications.store.ts
addNotification(message: string, type: 'success' | 'error' | 'warning' | 'info')
removeNotification(id: string)
clearNotifications()
```

#### 2. **ApplicationStatusBadge** (`src/components/ui/application-status-badge.tsx`)

**Propósito:** Badge para mostrar estado de aplicaciones

**Estados:**
- PENDING (Amarillo)
- APPROVED (Verde)
- REJECTED (Rojo)
- IN_REVIEW (Azul)
- INTERVIEW_SCHEDULED (Morado)

#### 3. **DatePicker** (`src/components/ui/date-picker/date-picker.tsx`)

**Propósito:** Selector de fecha con calendario

**Características:**
- Integración con React Hook Form
- Formato personalizable
- Min/Max dates
- Disabled dates

#### 4. **Tabs** (`src/components/ui/tabs.tsx`)

**Propósito:** Sistema de tabs usando Radix UI

**Uso:**
```tsx
<Tabs defaultValue="tab1">
  <TabsList>
    <TabsTrigger value="tab1">Tab 1</TabsTrigger>
    <TabsTrigger value="tab2">Tab 2</TabsTrigger>
  </TabsList>
  <TabsContent value="tab1">
    Content 1
  </TabsContent>
  <TabsContent value="tab2">
    Content 2
  </TabsContent>
</Tabs>
```

### Componentes de Formularios

#### 1. **LoginForm** (`src/app/auth/login/components/LoginForm.tsx`)

**Propósito:** Formulario de inicio de sesión

**Campos:**
- Email (validación)
- Password (min 6 caracteres)
- Remember me (opcional)

**Flujo:**
1. Validación con Zod
2. Submit a login action
3. Verificar múltiples roles
4. Redirect a select-role si aplica
5. O finalizar sesión directamente

#### 2. **RegisterForm** (`src/app/auth/register/components/RegisterForm.tsx`)

**Propósito:** Formulario de registro de candidatos

**Campos:**
- Nombre
- Apellido
- Email
- Password
- Confirmar Password
- Términos y condiciones (checkbox)

**Validaciones Zod:**
```typescript
{
  nombre: z.string().min(2),
  apellido: z.string().min(2),
  correo: z.string().email(),
  contrasena: z.string().min(6),
  confirmarContrasena: z.string(),
}
```

#### 3. **InterviewDateTimePicker** (`src/components/InterviewDateTimePicker.tsx`)

**Propósito:** Selector de fecha/hora para agendar entrevistas

**Características:**
- React DatePicker integrado
- Selector de hora
- Validación de fecha mínima (hoy)
- Notas adicionales (textarea)
- Integración con React Hook Form

### Componentes de Admin

#### 1. **EmailTemplateModal** (`src/app/admin/dashboard/templates/components/EmailtemplateModal.tsx`)

**Propósito:** Modal para crear/editar plantillas de email

**Campos:**
- Nombre de la plantilla
- Subject
- Body (React Quill editor)
- Variables dinámicas disponibles

**Variables soportadas:**
```
{{nombre}}
{{apellido}}
{{correo}}
{{empresa}}
{{posicion}}
{{fecha}}
```

#### 2. **CandidateProfileContext** (`src/app/admin/dashboard/context/CandidateProfileContext.tsx`)

**Propósito:** Context para gestionar el perfil del candidato en vista de admin

**Estado compartido:**
- Información personal
- Educación
- Experiencia
- Skills
- Video de presentación
- Documentos
- Estado de aplicaciones

### Componentes de Empresas

#### 1. **ClientApplicantsModal** (`src/app/companies/dashboard/components/ClientApplicantsModal.tsx`)

**Propósito:** Modal para ver y gestionar aplicantes a una oferta

**Características:**
- Lista de aplicantes con filtros
- Ver perfil completo
- Acciones:
  - Aprobar
  - Rechazar
  - Agendar entrevista
  - Enviar mensaje
- Estado de cada aplicante
- Búsqueda y filtros

#### 2. **EmployeesTable** (`src/app/companies/dashboard/components/EmployeesTable.tsx`)

**Propósito:** Tabla para listar empleados de la empresa

**Columnas:**
- Nombre completo
- Email
- Posición
- Fecha de inicio
- Estado (Activo/Inactivo)
- Acciones (Ver, Editar, Eliminar)

**Características:**
- Paginación
- Búsqueda
- Ordenamiento
- Acciones en masa

#### 3. **HeaderDashboard** (`src/app/companies/components/HeaderDashboard.tsx`)

**Propósito:** Header del dashboard de empresas

**Elementos:**
- Logo de la empresa
- Nombre de la empresa activa
- Notificaciones
- Perfil de usuario

#### 4. **TabsNavigation** (`src/app/companies/components/TabsNavigation.tsx`)

**Propósito:** Navegación por tabs del dashboard de empresas

**Tabs:**
- Dashboard (overview)
- Offers
- Employees
- Team Members
- Account

### Componentes de Profile

#### 1. **ViewSkillsModal** (`src/app/profile/components/ViewSkillsModal.tsx`)

**Propósito:** Modal para ver/editar skills del candidato

**Características:**
- Lista de skills con nivel
- Agregar nuevas skills
- Eliminar skills
- Categorías (técnicas, blandas, idiomas)

#### 2. **ViewVideoModal** (`src/app/profile/components/ViewVideoModal.tsx`)

**Propósito:** Modal para ver/subir video de presentación

**Características:**
- Preview del video
- Upload de nuevo video
- Validación de formato y tamaño
- Progress bar de upload

#### 3. **ViewFormularioModal** (`src/app/profile/components/ViewFormularioModal.tsx`)

**Propósito:** Modal para el formulario completo del perfil

**Secciones:**
- Información personal
- PC Requirements
- Availability
- Work preferences

### Componentes de Modales

#### 1. **ConfirmDeleteModal** (`src/app/components/ConfirmDeleteModal.tsx`)

**Propósito:** Modal de confirmación para eliminar elementos

**Props:**
```typescript
{
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  itemName?: string;
}
```

#### 2. **ConfirmPauseModal** (`src/app/components/ConfirmPauseModal.tsx`)

**Propósito:** Modal para confirmar pausa de ofertas

**Características:**
- Explicación del impacto
- Opción de pausar temporalmente
- Fecha de reactivación (opcional)

#### 3. **ViewOfferModal** (`src/app/components/ViewOfferModal.tsx`)

**Propósito:** Modal para ver detalles completos de una oferta

**Información mostrada:**
- Título y descripción
- Empresa
- Ubicación
- Tipo de contrato
- Salario
- Requisitos
- Beneficios
- Fecha de publicación

#### 4. **EditOfferModal** (`src/app/components/EditOfferModal.tsx`)

**Propósito:** Modal para editar oferta existente

**Campos editables:**
- Título
- Descripción (Quill editor)
- Requisitos
- Salario
- Beneficios
- Estado (Activa/Pausada)

### Componentes de E-Sign

#### 1. **SignPage** (`src/features/esign/components/SignPage.tsx`)

**Propósito:** Página principal de firma electrónica

**Características:**
- Viewer de PDF
- Canvas de firma
- Campos de formulario
- Progress bar de firmantes
- Validación antes de submit

#### 2. **EsignFieldCanvas** (`src/features/esign/components/EsignFieldCanvas.tsx`)

**Propósito:** Canvas para capturar firma manuscrita

**Características:**
- SignaturePad integrado
- Botón de limpiar
- Preview de firma
- Export a imagen

#### 3. **RecipientProgressBar** (`src/features/esign/components/RecipientProgressBar.tsx`)

**Propósito:** Barra de progreso mostrando quién ha firmado

**Visualización:**
```
[✓] John Doe - Firmado (12/01/2026)
[⏳] Jane Smith - Pendiente
[ ] Robert Johnson - Pendiente
```

#### 4. **PdfSignViewer** (`src/app/esign/public/sign/components/PdfSignViewer.tsx`)

**Propósito:** Visor de PDF con campos de firma interactivos

**Características:**
- Renderizado de PDF con react-pdf
- Overlay de campos de firma
- Highlight de campos requeridos
- Zoom y navegación de páginas
- Validación de campos completados

---

## Gestión de Estado

### Stores de Zustand

#### 1. **auth.store.ts** - Estado de Autenticación

**Ubicación:** `src/store/auth.store.ts`

**Interfaz:**
```typescript
interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  token: string | null;
  
  setUser: (user: User | null) => void;
  setAuthenticated: (status: boolean) => void;
  setLoading: (status: boolean) => void;
  logout: () => Promise<void>;
  setToken: (token: string) => void;
}
```

**Características especiales:**
- **Persistencia:** Usa `zustand/persist` para guardar en localStorage
- **Sincronización:** Se sincroniza con cookies del servidor en `onRehydrateStorage`
- **Logout:** Llama a `/api/auth/logout` para limpiar cookies del servidor

**Uso:**
```typescript
const { user, isAuthenticated, setUser, logout } = useAuthStore();
```

#### 2. **notifications.store.ts** - Sistema de Notificaciones

**Ubicación:** `src/store/notifications.store.ts`

**Interfaz:**
```typescript
interface Notification {
  id: string;
  message: string;
  type: 'success' | 'error' | 'warning' | 'info';
  duration?: number;
}

interface NotificationsState {
  notifications: Notification[];
  addNotification: (message: string, type: NotificationType) => void;
  removeNotification: (id: string) => void;
  clearNotifications: () => void;
}
```

**Uso:**
```typescript
const addNotification = useNotificationStore((s) => s.addNotification);

// Mostrar notificación
addNotification('Perfil actualizado correctamente', 'success');
```

#### 3. **app-notifications.store.ts** - Notificaciones de la App

**Ubicación:** `src/store/app-notifications.store.ts`

**Propósito:** Gestionar notificaciones en tiempo real de la aplicación (mensajes, actualizaciones de estado, etc.)

**Similar a notifications.store pero enfocado en notificaciones persistentes y de sistema**

### Contexts de React

#### 1. **ProfileContext** - Contexto del Perfil

**Ubicación:** `src/app/profile/context/ProfileContext.tsx`

**Propósito:** Compartir estado del perfil entre componentes de la página de perfil

**Estado:**
- Información personal
- Educación (array)
- Experiencia (array)
- Skills (array)
- Video URL
- Documentos
- Estado de completitud

**Acciones:**
- updatePersonalInfo
- addEducation / updateEducation / deleteEducation
- addExperience / updateExperience / deleteExperience
- addSkill / deleteSkill
- uploadVideo
- calculateProfileCompletion

#### 2. **CandidateProfileContext** - Contexto de Perfil de Candidato (Admin)

**Ubicación:** `src/app/admin/dashboard/context/CandidateProfileContext.tsx`

**Propósito:** Estado del candidato siendo revisado por un admin

**Similar a ProfileContext pero con permisos de lectura/escritura limitados y funciones adicionales para admin**

#### 3. **CompaniesContext** - Contexto de Empresas

**Ubicación:** `src/app/companies/context/CompaniesContext.tsx`

**Propósito:** Gestionar estado compartido entre páginas de empresas

**Estado:**
- Empresa activa
- Ofertas de la empresa
- Empleados
- Aplicaciones pendientes
- Métricas del dashboard

---

## Servicios y APIs

### Axios Clients

El proyecto implementa **tres instancias de Axios** para diferentes contextos:

#### 1. **axios.instance.ts** - Instancia Base

**Ubicación:** `src/services/axios.instance.ts`

**Propósito:** Configuración base compartida

```typescript
const axiosInstance = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});
```

#### 2. **axios.client.ts** - Client-Side

**Ubicación:** `src/services/axios.client.ts`

**Propósito:** Cliente para uso en Client Components

**Características:**
- Interceptor de request: Agrega token desde auth store
- Interceptor de response: Maneja errores 401 (redirect a login)
- Refresh token automático (si implementado)

```typescript
axiosClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

#### 3. **axios.server.ts** - Server-Side

**Ubicación:** `src/services/axios.server.ts`

**Propósito:** Cliente para uso en Server Actions y Server Components

**Características:**
- Lee token de cookies del servidor
- Usado en Server Actions
- No tiene acceso a Zustand store

```typescript
export async function createServerAxios() {
  const cookieStore = cookies();
  const token = cookieStore.get('auth_token')?.value;
  
  const instance = axios.create({
    baseURL: process.env.NEXT_PUBLIC_API_URL,
    headers: {
      Authorization: token ? `Bearer ${token}` : '',
    },
  });
  
  return instance;
}
```

### Server Actions por Módulo

#### Authentication Actions

**Ubicación:** `src/app/auth/`

**Acciones principales:**
- `loginAction` - Login de usuario
- `registerAction` - Registro de candidato
- `logoutAction` - Cerrar sesión
- `resetPasswordAction` - Reset de contraseña
- `verifyTokenAction` - Verificar token de reset

#### Profile Actions

**Ubicación:** `src/app/profile/actions/`

**Archivos:**
1. **profile.actions.ts**
   - `getProfile` - Obtener perfil completo
   - `updatePersonalInfo` - Actualizar info personal
   - `updatePCRequirements` - Requisitos de PC
   - `updateAvailability` - Disponibilidad

2. **education.actions.ts**
   - `getEducation` - Lista de educación
   - `addEducation` - Agregar educación
   - `updateEducation` - Actualizar educación
   - `deleteEducation` - Eliminar educación

3. **experience.actions.ts**
   - `getExperience` - Lista de experiencia
   - `addExperience` - Agregar experiencia
   - `updateExperience` - Actualizar experiencia
   - `deleteExperience` - Eliminar experiencia

4. **bank-info.actions.ts**
   - `getBankInfo` - Obtener info bancaria
   - `updateBankInfo` - Actualizar info bancaria

5. **formulario.actions.ts**
   - `getFormulario` - Formulario completo
   - `updateFormulario` - Actualizar formulario

#### Offers Actions

**Ubicación:** `src/app/pages/offers/actions/`

**Archivos:**
1. **jobs.actions.ts**
   - `getOffers` - Lista de ofertas con filtros y paginación
   - `getOfferById` - Detalle de oferta
   - `applyToOffer` - Postularse a oferta

2. **user-status.actions.ts**
   - `checkUserApplicationStatus` - Verificar si ya aplicó
   - `getUserProfileCompleteness` - Verificar completitud del perfil

#### Applications Actions

**Ubicación:** `src/app/applications/actions/`

**applications.actions.ts:**
- `getMyApplications` - Mis aplicaciones con paginación
- `getApplicationById` - Detalle de aplicación
- `withdrawApplication` - Retirar aplicación

#### Company Actions

**Ubicación:** `src/app/companies/dashboard/actions/`

**Archivos:**
1. **offers.actions.ts**
   - `getCompanyOffers` - Ofertas de la empresa
   - `createOffer` - Crear nueva oferta
   - `updateOffer` - Actualizar oferta
   - `deleteOffer` - Eliminar oferta
   - `pauseOffer` - Pausar/reactivar oferta

2. **applicants.actions.ts**
   - `getOfferApplicants` - Aplicantes a una oferta
   - `updateApplicantStatus` - Cambiar estado de aplicante
   - `rejectApplicant` - Rechazar aplicante
   - `approveApplicant` - Aprobar aplicante

3. **interview.actions.ts**
   - `scheduleInterview` - Agendar entrevista
   - `rescheduleInterview` - Reagendar
   - `cancelInterview` - Cancelar entrevista
   - `getInterviews` - Lista de entrevistas

4. **employee.actions.ts**
   - `getEmployees` - Lista de empleados
   - `addEmployee` - Agregar empleado
   - `updateEmployee` - Actualizar empleado
   - `deleteEmployee` - Eliminar empleado

5. **offers-with-accepted.actions.ts**
   - `getOffersWithAcceptedCandidates` - Ofertas con candidatos aceptados
   - (Para dashboard de empresa)

#### Admin Actions

**Ubicación:** `src/app/admin/dashboard/`

**Módulos principales:**

1. **Candidates** (`candidates/actions/`)
   - `getCandidates` - Lista de candidatos
   - `getCandidateProfile` - Perfil completo
   - `updateCandidateStatus` - Actualizar estado
   - `bulkUpdateCandidates` - Actualización masiva

2. **Offers** (`offers/actions/`)
   - `getAllOffers` - Todas las ofertas (admin)
   - `approveOffer` - Aprobar oferta de empresa
   - `rejectOffer` - Rechazar oferta

3. **Templates** (`templates/actions/`)
   - `getEmailTemplates` - Lista de plantillas
   - `createTemplate` - Crear plantilla
   - `updateTemplate` - Actualizar plantilla
   - `deleteTemplate` - Eliminar plantilla

4. **Notifications** (`notifications/actions/`)
   - `sendNotification` - Enviar notificación
   - `sendBulkNotifications` - Envío masivo

5. **E-Sign** (`esign/actions/`)
   - `createDocument` - Crear documento a firmar
   - `getDocuments` - Lista de documentos
   - `sendForSignature` - Enviar para firmar

#### Super Admin Actions

**Ubicación:** `src/app/admin/superAdmin/`

1. **users-roles** (`users-roles/actions/users-roles.actions.ts`)
   - `searchUsuarios` - Buscar usuarios (con filtros)
   - `updateUsuarioRoles` - Actualizar roles de usuario
   - `searchCompanies` - Buscar empresas
   - `assignUsuarioToCompanyEmployee` - Asignar usuario a empresa
   - `getUsuarioCompanyAssociation` - Ver asociaciones de empresa
   - `setCompanyResponsible` - Asignar responsable de empresa
   - `clearCompanyResponsible` - Quitar responsable
   - `removeUsuarioCompanyEmployee` - Quitar empleado de empresa

2. **payments** (`payments/actions/`)
   - `getConsolidatedPayments` - Pagos consolidados
   - `approvePayment` - Aprobar pago
   - `generatePaymentReport` - Generar reporte

#### Current Application Actions

**Ubicación:** `src/app/currentApplication/actions/`

1. **current-contract.actions.ts**
   - `getCurrentContract` - Contrato activo
   - `getContractDocuments` - Documentos del contrato
   - `downloadDocument` - Descargar documento

2. **invoices.actions.ts**
   - `getInvoices` - Lista de facturas
   - `createInvoice` - Crear factura
   - `downloadInvoice` - Descargar factura PDF
   - `getInvoiceById` - Detalle de factura

#### Account Actions

**Ubicación:** `src/app/account/actions/account.actions.ts`

- `getAccountInfo` - Información de la cuenta
- `updateAccountInfo` - Actualizar cuenta
- `changePassword` - Cambiar contraseña
- `deleteAccount` - Eliminar cuenta

---

## Módulos Funcionales

### 1. Módulo de Perfil de Candidato

**Ubicación:** `src/app/profile/`

**Componentes:**
- `page.tsx` - Página principal del perfil
- `layout.tsx` - Layout con navegación por tabs

**Tabs del Perfil:**
1. **Personal Info**
   - Nombre, apellido
   - Email, teléfono
   - País, ciudad
   - LinkedIn, portfolio

2. **Education**
   - Institución
   - Título obtenido
   - Fecha inicio/fin
   - Descripción

3. **Experience**
   - Empresa
   - Posición
   - Fecha inicio/fin
   - Responsabilidades

4. **Skills**
   - Skill técnicas
   - Skills blandas
   - Idiomas con nivel

5. **Video Introduction**
   - Upload de video
   - Preview
   - Requisitos: max 2min, MP4/WebM

6. **PC Requirements**
   - Especificaciones técnicas
   - Internet speed
   - Disponibilidad de backup

7. **Bank Information**
   - Banco
   - Tipo de cuenta
   - Número de cuenta
   - Routing number

**Context:** ProfileContext para compartir estado

### 2. Módulo de Ofertas

**Ubicación:** `src/app/pages/offers/`

**Funcionalidades:**

#### Vista de Candidato:
- **Lista de ofertas** con filtros:
  - Por título
  - Por ubicación
  - Por tipo de contrato
  - Por salario
  - Por empresa
- **Detalle de oferta**
- **Botón de aplicación** (con validaciones)

#### Guards de Acceso:
- `OffersAccessGuard` - Verifica autenticación
- `OfferDetailGuard` - Verifica perfil completo

#### Componentes:
- `JobFilters.tsx` - Filtros de búsqueda
- `FilterModal.tsx` - Modal de filtros avanzados
- Card de oferta con información resumida

### 3. Módulo de Aplicaciones

**Ubicación:** `src/app/applications/`

**Funcionalidades:**
- Lista de aplicaciones del candidato
- Estado de cada aplicación
- Timeline de progreso
- Retiro de aplicación (si permitido)

**Estados de Aplicación:**
- PENDING - Pendiente de revisión
- IN_REVIEW - En revisión
- INTERVIEW_SCHEDULED - Entrevista agendada
- APPROVED - Aprobada
- REJECTED - Rechazada
- WITHDRAWN - Retirada por candidato

### 4. Módulo de Dashboard de Empresa

**Ubicación:** `src/app/companies/dashboard/`

**Secciones:**

#### 1. **Overview (Dashboard)**
   - Métricas clave:
     - Total de ofertas activas
     - Total de empleados
     - Aplicaciones pendientes
     - Entrevistas programadas
   - Gráficos de actividad
   - Últimas aplicaciones

#### 2. **Offers**
   - Lista de ofertas de la empresa
   - Crear nueva oferta
   - Editar/Pausar/Eliminar
   - Ver aplicantes por oferta

#### 3. **Employees**
   - Lista de empleados contratados
   - Agregar nuevo empleado
   - Editar información
   - Ver contratos y documentos

#### 4. **Team Members**
   - Lista de usuarios con acceso al dashboard
   - Invitar nuevos miembros
   - Gestionar permisos

**Componentes Clave:**
- `HeaderDashboard` - Header con info de empresa
- `TabsNavigation` - Navegación por secciones
- `EmployeesTable` - Tabla de empleados
- `ClientApplicantsModal` - Modal de aplicantes

### 5. Módulo de Admin Dashboard

**Ubicación:** `src/app/admin/dashboard/`

**Secciones:**

#### 1. **Dashboard**
   - Métricas globales del sistema
   - Estadísticas de usuarios
   - Actividad reciente

#### 2. **Candidates**
   - Lista de todos los candidatos
   - Filtros avanzados
   - Ver perfil completo
   - Actualizar estado
   - Enviar notificaciones

#### 3. **Clients (Empresas)**
   - Lista de empresas registradas
   - Ver detalles
   - Gestionar suscripciones
   - Ver actividad

#### 4. **Offers**
   - Todas las ofertas del sistema
   - Aprobar/Rechazar ofertas de empresas
   - Editar si necesario
   - Ver métricas por oferta

#### 5. **Process (Procesos de Reclutamiento)**
   - Pipeline de reclutamiento
   - Etapas configurables
   - Mover candidatos entre etapas
   - Notificaciones automáticas

#### 6. **Templates**
   - Plantillas de email
   - Plantillas de contratos
   - Plantillas de documentos
   - Editor visual (Quill)

#### 7. **E-Sign**
   - Crear documentos para firma
   - Ver documentos pendientes
   - Ver documentos firmados
   - Gestionar firmantes

#### 8. **Notifications**
   - Centro de notificaciones
   - Envío de notificaciones individuales
   - Envío masivo
   - Historial

#### 9. **Contracts**
   - Lista de contratos activos
   - Ver detalles
   - Cancelar contratos
   - Gestionar renovaciones

#### 10. **Emails**
   - Log de emails enviados
   - Ver contenido
   - Reenviar si necesario
   - Estadísticas de apertura

### 6. Módulo de Super Admin

**Ubicación:** `src/app/admin/superAdmin/`

**Funcionalidades Exclusivas:**

#### 1. **Users & Roles**
   - Buscar usuarios por email
   - Ver todos los roles de un usuario
   - Asignar/Quitar roles
   - Gestionar asociaciones de empresa:
     - Asignar usuario como empleado de empresa
     - Asignar usuario como responsable de empresa
     - Quitar asociaciones

**Flujo de Asignación de Roles:**
```
1. Buscar usuario por email
2. Ver roles actuales
3. Click "Edit"
4. Seleccionar roles (checkboxes):
   ☐ ADMIN
   ☐ EMPLEADO_ADMIN
   ☐ ADMIN_RECLUTAMIENTO
   ☐ EMPLEADO_EMPRESA
   ☐ CANDIDATO
5. Si EMPLEADO_EMPRESA:
   - Buscar empresa
   - Seleccionar empresa
   - Asignar como employee o responsible
6. Guardar cambios
```

#### 2. **Payments (Consolidated)**
   - Ver todos los pagos del sistema
   - Aprobar pagos pendientes
   - Generar reportes consolidados
   - Filtrar por periodo, empresa, estado

#### 3. **Users (Advanced)**
   - Vista avanzada de usuarios
   - Acciones masivas
   - Export de datos
   - Análisis de actividad

### 7. Módulo de Current Application (Contrato Activo)

**Ubicación:** `src/app/currentApplication/`

**Para candidatos con contrato activo**

**Tabs:**

#### 1. **Contract Info**
   - Empresa
   - Posición
   - Tipo de contrato
   - Fecha de inicio
   - Fecha de fin (si aplica)
   - Salario
   - Estado

#### 2. **Documents**
   - Contrato firmado
   - NDA (si aplica)
   - Políticas de la empresa
   - Otros documentos
   - Download individual o bulk

**Componente:** `DocumentTemplates.tsx`

#### 3. **Invoices**
   - Lista de facturas
   - Generar nueva factura
   - Download PDF
   - Ver estado (Paid/Pending)

**Actions:**
- `invoices.actions.ts` - Gestión de facturas

#### 4. **Templates**
   - Plantillas de documentos disponibles
   - Preview
   - Download

### 8. Módulo de E-Sign (Firma Electrónica)

**Ubicación:** `src/app/esign/` y `src/features/esign/`

**Flujos:**

#### A. **Flujo Privado (Provider)** `/esign/provider/[token]`
   - Para firmantes con cuenta en el sistema
   - Requiere autenticación
   - Redirect a sign page con validación

#### B. **Flujo Público** `/esign/public/sign/[token]`
   - Para firmantes externos sin cuenta
   - No requiere autenticación
   - Solo token único de acceso

**Proceso de Firma:**

1. **Acceso al documento**
   - Usuario recibe email con link único
   - Click en link → validación de token
   - Si válido, cargar documento

2. **Vista del documento**
   - `PdfSignViewer` renderiza el PDF
   - Campos de firma resaltados
   - Progress bar muestra quién ha firmado

3. **Completar campos**
   - Campos de firma: SignaturePad
   - Campos de texto: Input
   - Campos de fecha: Auto-llenado
   - Campos de iniciales: SignaturePad pequeño

4. **Validación**
   - Todos los campos requeridos completos
   - Firma capturada
   - Confirmar identidad

5. **Submit**
   - POST firma al backend
   - Backend actualiza documento
   - Marca al firmante como completado
   - Si todos firmaron → generar PDF final
   - Notificar a admin y otros firmantes

**Componentes:**
- `SignPage.tsx` - Página de firma
- `EsignFieldCanvas.tsx` - Canvas de firma
- `RecipientProgressBar.tsx` - Barra de progreso
- `PdfSignViewer.tsx` - Visor de PDF con campos

### 9. Módulo de Notifications

**Sistema de notificaciones en tiempo real**

**Componentes:**
- `NotificationsBell.tsx` - Icono de campana con badge
- `NotificationsSidebar.tsx` - Sidebar con lista de notificaciones

**Tipos de Notificaciones:**
- Aplicación nueva (para empresas)
- Cambio de estado de aplicación (para candidatos)
- Entrevista agendada
- Mensaje nuevo
- Documento pendiente de firma
- Invoice aprobado
- Sistema (mantenimiento, actualizaciones)

**Store:** `app-notifications.store.ts`

**Funcionalidades:**
- Mark as read
- Mark all as read
- Delete notification
- Filter por tipo
- Real-time updates (si implementado con WebSocket)

### 10. Módulo de Account Settings

**Ubicación:** `src/app/account/`

**Para todos los roles**

**Secciones:**

#### 1. **Profile Settings**
   - Cambiar email
   - Cambiar contraseña
   - Actualizar foto de perfil

#### 2. **Preferences**
   - Idioma
   - Zona horaria
   - Notificaciones por email
   - Newsletter

#### 3. **Privacy**
   - Visibilidad del perfil
   - Configuración de privacidad
   - Export de datos (GDPR)
   - Eliminar cuenta

#### 4. **Security**
   - Autenticación de dos factores (2FA)
   - Sesiones activas
   - Log de actividad

### 11. Módulo de Bonifications

**Ubicación:** `src/app/bonifications/`

**Propósito:** Sistema de bonificaciones e incentivos adicionales

**Funcionalidades:**
- Ver bonificaciones disponibles
- Aplicar a programas de incentivos
- Ver historial de bonificaciones
- Calcular bonificaciones proyectadas

---

## Routing y Middleware

### Next.js App Router

El proyecto usa **Next.js App Router** (carpeta `app/`):

**Ventajas:**
- Server Components por defecto
- Layouts anidados
- Loading y error states automáticos
- Streaming y Suspense
- Server Actions integrados

### Estructura de Rutas

```
/                           → Home pública
/pages/home                 → Home alternativa
/pages/about                → Acerca de
/pages/services             → Servicios
/pages/team                 → Equipo
/pages/contact              → Contacto
/pages/offers               → Ofertas públicas
/pages/privacy-policy       → Política de privacidad
/politica-datos             → Política de datos

/auth/login                 → Login
/auth/login/select-role     → Selección de rol
/auth/register              → Registro
/auth/forgot-password       → Recuperar contraseña
/auth/reset-password        → Resetear contraseña
/auth/forced-logout         → Logout forzado

/profile                    → Perfil de candidato
/applications               → Mis aplicaciones
/currentApplication         → Contrato activo
/account                    → Configuración de cuenta
/bonifications              → Bonificaciones

/companies/dashboard                → Dashboard de empresa
/companies/dashboard/offers         → Ofertas de empresa
/companies/dashboard/employees      → Empleados
/companies/dashboard/listEmployees  → Lista de empleados
/companies/dashboard/team-members   → Miembros del equipo
/companies/account                  → Cuenta de empresa

/admin/dashboard                → Dashboard de admin
/admin/dashboard/candidates     → Candidatos
/admin/dashboard/clients        → Clientes (empresas)
/admin/dashboard/offers         → Ofertas
/admin/dashboard/process        → Procesos
/admin/dashboard/templates      → Plantillas
/admin/dashboard/esign          → E-Sign
/admin/dashboard/notifications  → Notificaciones
/admin/dashboard/contracts      → Contratos
/admin/dashboard/emails         → Emails
/admin/dashboard/postulants     → Postulantes
/admin/dashboard/save-offers    → Ofertas guardadas
/admin/dashboard/team-members   → Miembros del equipo
/admin/dashboard/account        → Cuenta de admin

/admin/superAdmin                  → Panel de super admin
/admin/superAdmin/users            → Usuarios avanzado
/admin/superAdmin/users-roles      → Gestión de roles
/admin/superAdmin/payments         → Pagos consolidados

/esign/provider/[token]       → Firma electrónica (privado)
/esign/public/sign/[token]    → Firma electrónica (público)

/health                       → Health check
/api/health                   → API health check
```

### Middleware de Next.js

**Archivo:** `src/middleware.ts`

**Propósito:** Protección de rutas y redirecciones basadas en autenticación y roles

#### Flujo del Middleware

```
Request → Middleware
           │
           ├─ Verificar cookies (auth_token, user_info)
           │
           ├─ Determinar rol del usuario
           │
           ├─ ¿Es ruta pública?
           │   ├─ Sí → Next()
           │   └─ No → Continuar verificaciones
           │
           ├─ ¿Usuario autenticado?
           │   ├─ No → Redirect /auth/login
           │   └─ Sí → Continuar
           │
           ├─ ¿Intenta acceder a auth routes?
           │   └─ Sí → Redirect a dashboard según rol
           │
           ├─ ¿Tiene permisos para la ruta?
           │   ├─ No → Redirect /auth/forced-logout
           │   └─ Sí → Next()
           │
           └─ Next()
```

#### Configuración del Middleware

```typescript
export const config = {
  matcher: [
    '/((?!_next/|api/|static/|favicon.ico|.*\\..*|[\\w-]+\\.\\w+).*)',
  ],
};
```

**Excluye:**
- Archivos estáticos de Next.js (`_next/`)
- Rutas de API (manejadas por API routes)
- Archivos públicos (`static/`, `favicon.ico`)
- Archivos con extensión (`.png`, `.jpg`, etc.)

### Protección de Rutas por Rol

#### Matriz de Acceso

| Ruta | CANDIDATO | EMPRESA | EMPLEADO_EMPRESA | ADMIN | EMPLEADO_ADMIN | ADMIN_RECLUTAMIENTO |
|------|-----------|---------|------------------|-------|----------------|---------------------|
| `/` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `/pages/*` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `/profile` | ✓ | ✗ | ✗ | ✓ (view) | ✓ (view) | ✓ (view) |
| `/applications` | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| `/currentApplication` | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| `/companies/*` | ✗ | ✓ | ✓ (limited) | ✗ | ✗ | ✗ |
| `/admin/dashboard/*` | ✗ | ✗ | ✗ | ✓ | ✓ | ✓ |
| `/admin/superAdmin/*` | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| `/esign/public/*` | ✓ (public) | ✓ (public) | ✓ (public) | ✓ (public) | ✓ (public) | ✓ (public) |

### Redirecciones Automáticas

**Después de Login:**
```typescript
if (rol === "EMPRESA" || rol === "EMPLEADO_EMPRESA") {
  redirect("/companies/dashboard");
} else if (rol === "ADMIN" || rol === "EMPLEADO_ADMIN" || rol === "ADMIN_RECLUTAMIENTO") {
  redirect("/admin/dashboard");
} else if (perfilCompleto === "INCOMPLETO") {
  redirect("/profile");
} else {
  redirect("/pages/offers");
}
```

**Intentos de Acceso No Autorizado:**
- Usuario no autenticado → `/auth/login`
- Usuario sin permisos → `/auth/forced-logout?reason=unauthorized`
- Empresa intentando acceder a rutas de admin → `/companies/dashboard`
- Admin intentando acceder a rutas de empresa → `/admin/dashboard`

### API Routes

**Ubicación:** `src/app/api/`

**Endpoints:**

#### Authentication
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Registro
- `GET /api/auth/logout` - Logout (limpia cookies)
- `POST /api/auth/refresh` - Refresh token

#### Health Check
- `GET /api/health` - Health check del cliente

#### Special
- `POST /api/auth/login/with-company` - Login proxy para selección de empresa

**Nota:** La mayoría de la lógica está en Server Actions en lugar de API Routes

---

## Conclusiones y Recomendaciones

### Fortalezas del Proyecto

1. **Arquitectura Moderna**
   - Uso efectivo de Next.js 16 App Router
   - Server Components y Server Actions bien implementados
   - Separation of concerns clara

2. **Sistema de Roles Robusto**
   - 6 roles bien definidos con permisos claros
   - Middleware eficiente para protección de rutas
   - Flujo de selección de rol para usuarios multi-rol

3. **Componentes Reutilizables**
   - Biblioteca de componentes UI bien estructurada
   - Componentes modulares y fáciles de mantener
   - Uso de Radix UI para accesibilidad

4. **Gestión de Estado**
   - Zustand para estado global (ligero y eficiente)
   - Contexts para estado local específico
   - Persistencia donde es necesario

5. **Type Safety**
   - TypeScript en todo el proyecto
   - Interfaces bien definidas
   - Validación con Zod

6. **Documentación**
   - Carpeta `docs/` con documentación técnica extensa
   - README completo
   - Confluence documentation generada

### Áreas de Mejora Identificadas

#### 1. **Testing**
**Estado actual:** No se observan tests en la estructura

**Recomendaciones:**
- Agregar Jest y React Testing Library
- Implementar tests unitarios para componentes críticos
- Tests de integración para flujos principales
- E2E tests con Playwright o Cypress

**Estructura sugerida:**
```
src/
  __tests__/
    components/
    hooks/
    utils/
  app/
    [ruta]/
      __tests__/
        page.test.tsx
```

#### 2. **Performance**

**Optimizaciones sugeridas:**
- Implementar lazy loading para componentes pesados
- Code splitting más agresivo
- Optimización de imágenes (Next.js Image component)
- Caching de Server Actions
- React Server Components donde sea posible

**Ejemplo:**
```typescript
// Lazy load de modales
const EditOfferModal = dynamic(() => import('./EditOfferModal'), {
  loading: () => <ModalSkeleton />,
});
```

#### 3. **Error Handling**

**Mejoras sugeridas:**
- Error boundaries globales y por sección
- Logging de errores a servicio externo (Sentry, LogRocket)
- Mensajes de error más descriptivos para usuarios
- Retry logic para operaciones fallidas

**Implementación sugerida:**
```typescript
// app/error.tsx (global)
'use client'
 
export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    // Log to external service
    console.error(error)
  }, [error])
 
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}
```

#### 4. **Security**

**Recomendaciones:**
- Implementar rate limiting en API routes
- CSRF protection
- Content Security Policy headers
- Sanitización de inputs en Server Actions
- Auditoría de dependencias (npm audit)

**Next.js config sugerido:**
```typescript
// next.config.ts
const securityHeaders = [
  {
    key: 'X-Frame-Options',
    value: 'SAMEORIGIN',
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff',
  },
  // ... más headers
];
```

#### 5. **Accessibility (a11y)**

**Mejoras:**
- Auditoría con axe o Lighthouse
- ARIA labels en componentes interactivos
- Keyboard navigation completa
- Screen reader testing
- Focus management en modales

**Checklist:**
- [ ] Todos los botones tienen texto descriptivo
- [ ] Imágenes tienen alt text
- [ ] Forms tienen labels apropiados
- [ ] Color contrast ratio cumple WCAG AA
- [ ] Navegación por teclado funciona
- [ ] Screen readers pueden navegar el sitio

#### 6. **Monitoring y Analytics**

**Herramientas sugeridas:**
- **Web Vitals:** Next.js built-in reporting
- **Error Tracking:** Sentry
- **User Analytics:** Google Analytics 4 o Plausible
- **Performance Monitoring:** Vercel Analytics o New Relic
- **Logs:** Structured logging con Winston o Pino

**Implementación:**
```typescript
// app/layout.tsx
import { Analytics } from '@vercel/analytics/react';
 
export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

#### 7. **Internacionalización (i18n)**

**Para expansión futura:**
- next-intl o next-i18next
- Traducción de contenido
- Formatos de fecha/hora por locale
- Monedas localizadas

**Estructura sugerida:**
```
src/
  locales/
    en/
      common.json
      auth.json
      profile.json
    es/
      common.json
      auth.json
      profile.json
```

#### 8. **Mobile Optimization**

**Mejoras:**
- PWA capabilities (ya tiene manifest.json)
- Offline support con Service Worker
- App-like navigation en móvil
- Touch gestures
- Bottom navigation en móvil

#### 9. **Code Organization**

**Refactoring sugerido:**

```
src/
  app/
    (auth)/          # Auth routes grouped
      login/
      register/
    (dashboard)/     # Dashboard routes grouped
      admin/
      companies/
    (public)/        # Public pages grouped
      pages/
```

**Uso de Route Groups de Next.js para mejor organización**

#### 10. **Documentation**

**Mejorar:**
- JSDoc en funciones complejas
- Storybook para componentes UI
- API documentation (OpenAPI/Swagger)
- Architecture Decision Records (ADRs)
- Onboarding guide para nuevos developers

### Recomendaciones de Deployment

#### 1. **Environment Variables**
```env
# Production
NEXT_PUBLIC_API_URL=https://api.andesworkforce.com
NEXT_PUBLIC_APP_URL=https://andesworkforce.com
NODE_ENV=production

# Database
DATABASE_URL=***

# Auth
JWT_SECRET=***
COOKIE_SECRET=***

# Services
AWS_ACCESS_KEY_ID=***
AWS_SECRET_ACCESS_KEY=***
RESEND_API_KEY=***

# Monitoring
SENTRY_DSN=***
```

#### 2. **CI/CD Pipeline**

**GitHub Actions ya presente en:** `.github/workflows/deploy.yml`

**Mejoras sugeridas:**
```yaml
name: CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm test
      - run: pnpm lint
      - run: pnpm build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
```

#### 3. **Hosting**

**Recomendado:** Vercel (optimizado para Next.js)

**Alternativas:**
- AWS Amplify
- Netlify
- Railway
- Render

#### 4. **CDN y Caching**

**Configuración de headers de cache:**
```typescript
// next.config.ts
export default {
  async headers() {
    return [
      {
        source: '/static/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
};
```

### Métricas de Éxito

**KPIs a monitorear:**
- Time to Interactive (TTI) < 3s
- Largest Contentful Paint (LCP) < 2.5s
- First Input Delay (FID) < 100ms
- Cumulative Layout Shift (CLS) < 0.1
- Error rate < 1%
- API response time < 500ms
- User satisfaction > 4.5/5

### Roadmap Sugerido

#### Corto Plazo (1-3 meses)
- [ ] Implementar tests básicos
- [ ] Agregar error boundaries
- [ ] Mejorar logging
- [ ] Optimizar performance (lazy loading)
- [ ] Security audit

#### Mediano Plazo (3-6 meses)
- [ ] Implementar monitoreo completo
- [ ] Agregar analytics
- [ ] PWA capabilities
- [ ] Internacionalización
- [ ] Storybook para componentes

#### Largo Plazo (6-12 meses)
- [ ] Mobile app (React Native)
- [ ] Advanced analytics dashboard
- [ ] AI-powered candidate matching
- [ ] Video interview integration
- [ ] Blockchain-verified credentials

---

## Resumen Ejecutivo

### Descripción del Sistema

**Andes Client** es una plataforma de gestión de recursos humanos desarrollada con Next.js 16 que facilita la conexión entre candidatos y oportunidades laborales en América Latina. El sistema soporta tres tipos principales de usuarios: **Candidatos**, **Empresas** y **Administradores**, cada uno con funcionalidades específicas.

### Tecnologías Clave

- **Frontend:** Next.js 16 (App Router), React 19, TypeScript
- **Styling:** Tailwind CSS 4
- **Estado:** Zustand, React Context
- **Forms:** React Hook Form + Zod
- **HTTP:** Axios (client/server)
- **Documents:** React PDF, PDF.js, React Quill

### Módulos Principales

1. **Autenticación y Autorización** - Sistema robusto de roles con 6 tipos diferentes
2. **Perfiles de Candidatos** - Gestión completa de información profesional
3. **Ofertas Laborales** - Publicación, búsqueda y postulación
4. **Dashboard de Empresas** - Gestión de ofertas, candidatos y empleados
5. **Dashboard de Admin** - Supervisión y configuración del sistema
6. **Firma Electrónica** - Sistema de e-sign integrado
7. **Contratos y Facturas** - Gestión de documentos laborales

### Estado del Proyecto

**Madurez:** Producción
**Completitud:** ~90%
**Calidad del Código:** Alta (TypeScript, estructura clara)
**Documentación:** Buena (docs/ y README)
**Testing:** Área de mejora (no tests visibles)

### Próximos Pasos Críticos

1. Implementar suite de tests
2. Agregar monitoring y error tracking
3. Optimizar performance
4. Security audit
5. Mejorar accesibilidad

---

**Fin del Análisis**

_Este documento provee un análisis comprehensivo del proyecto CLIENT-ANDES, cubriendo arquitectura, componentes, flujos y recomendaciones para mejora continua._
