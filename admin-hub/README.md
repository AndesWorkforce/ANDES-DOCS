# Admin Hub — Documentación

Módulo de contabilidad/nómina: contratos, variables de ingreso, bonos, feriados, cargos y créditos al cliente.

Contexto de plataforma (CLIENT / API / servidores): [`../contexto-plataforma/`](../contexto-plataforma/README.md).

---

## Índice vigente

### Guías de desarrollo

| Archivo | Descripción |
|---|---|
| [GUIA_INCOME_VARIABLES_SENIORITY_HOLIDAYS.md](./GUIA_INCOME_VARIABLES_SENIORITY_HOLIDAYS.md) | Variables de ingreso, bono de antigüedad y feriados |
| [GUIA_TESTS_BILLING_FACTURACION.md](./GUIA_TESTS_BILLING_FACTURACION.md) | Tests de facturación al cliente |
| [FLUJO_FACTURACION_VALIDACION.md](./FLUJO_FACTURACION_VALIDACION.md) | Flujo de validación de facturas |
| [AVISOS_MAPEO_VALIDACION.md](./AVISOS_MAPEO_VALIDACION.md) | Avisos y mapeo de validación |
| [FORMATO_USD_ADMIN_HUB.md](./FORMATO_USD_ADMIN_HUB.md) | Formato USD |
| [ALERTS_SETUP.md](./ALERTS_SETUP.md) | Alertas |
| [HISTORIAS_USUARIO_VARIABLES_NOMINA.md](./HISTORIAS_USUARIO_VARIABLES_NOMINA.md) | HUs de variables de nómina |

### Operación de facturas / nóminas

| Archivo | Descripción |
|---|---|
| [RESUMEN_SINCRONIZACION_NOMINAS_FACTURAS.md](./RESUMEN_SINCRONIZACION_NOMINAS_FACTURAS.md) | Sincronización nóminas–facturas |
| [RESUMEN_VERIFICACION_DATOS_FACTURA.md](./RESUMEN_VERIFICACION_DATOS_FACTURA.md) | Verificación de datos de factura |

### Historias de usuario (API)

| Archivo | Descripción |
|---|---|
| [../HU-19-customer-charges-management.md](../HU-19-customer-charges-management.md) | Cargos al cliente |
| [../HU-20-customer-credits-management.md](../HU-20-customer-credits-management.md) | Créditos al cliente |

### Presentación

| Archivo | Descripción |
|---|---|
| [../PRESENTACION_ADMIN_HUB_FACTURACION.md](../PRESENTACION_ADMIN_HUB_FACTURACION.md) | Demo de facturación para administración |

PRs: [`../pr-history/2026/`](../pr-history/2026/).  
Videos: [`../video-scripts/`](../video-scripts/).

---

## Arquitectura del módulo

```
API-ANDES/src/admin-hub/
├── income-variables/
├── customer-charges/
├── customer-credits/
├── billing-summary/
└── admin-hub.module.ts
```

Rama de trabajo habitual: `admin-hub` en API-ANDES (prod sigue siendo `master`).
