# Admin Hub — Documentación

Sección de documentación centralizada del módulo **Admin Hub**: el módulo de contabilidad/nómina para administración de contratos, variables de ingreso, bonos y feriados.

> Los PR descriptions están en [`../pr-history/2026/`](../pr-history/2026/).  
> Los scripts de video están en [`../video-scripts/`](../video-scripts/).

---

## Índice de documentos

### Análisis y planificación

| Archivo | Descripción |
|---|---|
| [PLAN_ACCOUNTING_ADMIN_HUB.md](./PLAN_ACCOUNTING_ADMIN_HUB.md) | Plan completo de implementación del módulo contable (fases, sprint, modelos, endpoints) |
| [ANALISIS_COMPLETO_API_ANDES.md](./ANALISIS_COMPLETO_API_ANDES.md) | Análisis completo del estado de la API (módulos, endpoints, guards, etc.) |
| [ANALISIS_COMPLETO_CLIENT_ANDES.md](./ANALISIS_COMPLETO_CLIENT_ANDES.md) | Análisis completo del estado del cliente Next.js |

### Guías de desarrollo

| Archivo | Descripción |
|---|---|
| [GUIA_INCOME_VARIABLES_SENIORITY_HOLIDAYS.md](./GUIA_INCOME_VARIABLES_SENIORITY_HOLIDAYS.md) | Guía de desarrollo: Variables de ingreso, Bono de Antigüedad y Feriados (con fórmulas, endpoints y flujos) |
| [GUIA_TESTS_BILLING_FACTURACION.md](./GUIA_TESTS_BILLING_FACTURACION.md) | Tests del flujo de facturación al cliente: unit (32 casos) + e2e secuencial (charges → credits → income vars → total) |

---

## Arquitectura del módulo

```
API-ANDES/src/admin-hub/
├── income-variables/     # Variables de ingreso (CRUD + aprobación + anulación)
│   ├── dto/
│   ├── income-variables.controller.ts
│   ├── income-variables.service.ts   ← lógica de bono antigüedad aquí
│   └── income-variables.module.ts
├── customer-charges/     # Cargos al cliente (EQUIPO, CAPACITACION, etc.)
│   ├── dto/
│   ├── customer-charges.controller.ts
│   └── customer-charges.service.ts   ← estados: PENDIENTE → APROBADO → FACTURADO
├── customer-credits/     # Ajustes de factura al cliente (AjusteFacturaCliente)
│   ├── dto/
│   ├── customer-credits.controller.ts
│   └── customer-credits.service.ts   ← estados: PENDING → APPROVED
├── billing-summary/      # Resumen de facturación mensual
│   ├── billing-summary.controller.ts
│   └── billing-summary.service.ts    ← facturacionCliente + nominaContratista
└── admin-hub.module.ts
```

## Branch activo

- **API-ANDES**: `admin-hub`
- **CLIENT-ANDES**: pendiente integración UI

## Commits de referencia

- `edc4d28` — Bono Antigüedad + Income Variables completo (API-ANDES)
- `b5a40eb` — Guía dev Income Variables / Seniority / Holidays (ANDES-DOCS)
- `(pendiente)` — Tests billing-summary: unit 32 casos + e2e flujo completo
