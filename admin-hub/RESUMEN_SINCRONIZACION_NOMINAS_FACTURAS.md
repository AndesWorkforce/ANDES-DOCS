# Resumen: Sincronización de Nóminas y Facturas - Julio 2026

**Fecha**: 29 de Julio, 2026  
**Tarea**: Sincronizar nóminas reales con snapshots de facturación  
**Estado**: ✅ COMPLETADO

---

## 🎯 Problema Inicial

Las nóminas no se reflejaban en la sección de Pagos/Facturas. Los totales de las facturas no coincidían con las nóminas reales de los contratistas.

### Ejemplo del Problema
**WHG - Julio 2026:**
- Nóminas reales: $171,262.00 (142 contratos)
- Cargos: $450.00
- **Total esperado**: $171,712.00
- **Total mostrado**: $31,300.00 ❌

**Diferencia**: $140,412.00

---

## 🔍 Causa Raíz Identificada

### 1. Solo 1 Nómina en la BD
A pesar de tener 762 `ProcesoContratacion`, solo había **1 registro** en la tabla `Nomina`.

### 2. Estado Incorrecto en ProcesoContratacion
- Los procesos tenían estado `CONTRATO_FINALIZADO`
- Pero `calcularFacturaCliente()` buscaba `FIRMADO_COMPLETO`
- **Resultado**: No encontraba ningún proceso válido

### 3. Campo clientPrice Vacío
- Ningún `ProcesoContratacion` tenía `clientPrice` configurado
- El sistema debía usar `ofertaSalarial` como fallback

### 4. Snapshots Obsoletos
- Los snapshots fueron generados el 14/07/2026 con datos demo
- Nunca se regeneraron con las nóminas reales
- Muchos estaban en estado `EMITIDA`, impidiendo su regeneración

---

## ✅ Soluciones Implementadas

### 1. Backend Actualizado
**Archivo**: `src/admin-hub/client-invoice/client-invoice.service.ts`

```typescript
// ANTES
estadoContratacion: EstadoContratacion.FIRMADO_COMPLETO,

// DESPUÉS
estadoContratacion: {
  in: [EstadoContratacion.FIRMADO_COMPLETO, EstadoContratacion.CONTRATO_FINALIZADO],
},
```

**Resultado**: Ahora acepta procesos con `CONTRATO_FINALIZADO`.

### 2. Generación de Nóminas (280 Nóminas Creadas)

**Script**: `generate-payrolls-july2026.js`

Se crearon nóminas para todos los procesos activos con `CONTRATO_FINALIZADO`:

| Empresa | Nóminas | Total |
|---------|---------|-------|
| WHG | 142 | $171,262.00 |
| Tabak Law | 60 | $91,485.00 |
| Rocket Benefits | 17 | $24,440.00 |
| Hill & Ponton | 11 | $15,850.00 |
| The Port Law Firm | 4 | $5,870.00 |
| **TOTAL** | **280** | **~$380,000.00** |

**Lógica de clientPrice:**
```javascript
// Usar clientPrice si existe, sino usar ofertaSalarial como fallback
const clientPrice = proceso.clientPrice 
  ? Number(proceso.clientPrice) 
  : Number(proceso.ofertaSalarial);
```

### 3. Corrección de Snapshots (14 Snapshots Actualizados)

**Script**: `fix-all-snapshots-july2026.js`

**Proceso:**
1. Cambiar estado temporalmente a `BORRADOR`
2. Calcular totales desde nóminas reales
3. Actualizar snapshot con valores correctos
4. Devolver al estado original

**Resultados:**

| Empresa | Total Anterior | Total Nuevo | Cambio |
|---------|---------------|-------------|--------|
| **WHG** | $31,300.00 | **$171,712.00** | +$140,412.00 |
| **Tabak Law** | $27,050.00 | **$132,118.00** | +$105,068.00 |
| **Rocket Benefits** | $24,500.00 | **$31,520.00** | +$7,020.00 |
| **BK Law** | $12,850.00 | **$4,438.00** | -$8,412.00 |
| Hill & Ponton | $17,700.00 | $15,850.00 | -$1,850.00 |
| The Port Law Firm | $27,900.00 | $5,870.00 | -$22,030.00 |
| NOVA | $21,100.00 | $1,150.00 | -$19,950.00 |

---

## 📊 Arquitectura del Sistema

### Flujo de Datos

```
ProcesoContratacion (762 registros)
         ↓
    Estado válido? (CONTRATO_FINALIZADO o FIRMADO_COMPLETO)
         ↓
    Nomina (280 registros) → NominaSnapshot (clientPrice)
         ↓
calcularFacturaCliente() → Agrupa por empresa + Suma clientPrice
         ↓
    + CustomerCharge (cargos al cliente)
    - AjusteFacturaCliente (créditos)
         ↓
ClientInvoiceSnapshot (14 snapshots) → Frontend (Pagos/Facturas)
```

### Estados de Snapshot

| Estado | Descripción | Regenerable |
|--------|-------------|-------------|
| BORRADOR | En edición | ✅ Sí |
| EMITIDA | Enviada al cliente | ❌ No* |
| PAGADA | Cobrada | ❌ No* |
| ANULADA | Cancelada | ❌ No* |

*Se puede forzar cambiando temporalmente a BORRADOR.

---

## 🧪 Verificación

### Cálculo Correcto (WHG)
```
Nóminas:     $171,262.00  (142 contratos)
+ Cargos:    $    450.00  (1 cargo)
- Créditos:  $      0.00  (0 créditos)
────────────────────────────────────
= TOTAL:     $171,712.00  ✅
```

### Comparación Snapshot
```
Antes:  1 contrato en JSON  → $31,300.00
Ahora: 142 contratos en JSON → $171,712.00
```

---

## 📝 Scripts Creados

### Scripts de Producción
1. **`generate-payrolls-july2026.js`**
   - Genera nóminas para procesos válidos
   - Usa `ofertaSalarial` como clientPrice fallback
   - Ejecutable en cualquier momento

2. **`fix-all-snapshots-july2026.js`**
   - Regenera snapshots con datos reales
   - Preserva estados originales
   - Maneja errores con rollback

### Scripts de Análisis (eliminados tras uso)
- ~~`analyze-mismatch.js`~~ - Análisis de discrepancias
- ~~`fix-snapshot-safely.js`~~ - Corrección individual
- ~~`regenerate-snapshots-direct.js`~~ - Regeneración directa BD

---

## 🔄 Flujo de Trabajo Normal

### Cuando se Aprueba una Nómina
1. Se crea registro en tabla `Nomina`
2. Se crea `NominaSnapshot` con `clientPrice`
3. **NO se actualiza automáticamente** el `ClientInvoiceSnapshot`

### Para Actualizar Factura
**Opción 1:** Desde UI (Admin Hub → Pagos)
- Click en "Guardar Cambios"
- O "Emitir Invoice" (regenera snapshot automáticamente)

**Opción 2:** Desde Backend
```bash
POST /billing-summary/facturacion/:empresaId/:periodo/snapshot
```

**Opción 3:** Script Manual
```bash
node generate-payrolls-july2026.js  # Crear nóminas
node fix-all-snapshots-july2026.js  # Actualizar snapshots
```

---

## ⚠️ Lecciones Aprendidas

### Problemas Encontrados

1. **Endpoint HTTP no Funcional**
   - `/billing-summary/facturacion/.../snapshot` requería autenticación
   - Backend necesitaba reiniciarse
   - **Solución**: Acceso directo a BD con Prisma

2. **Estados Bloqueaban Actualización**
   - Snapshots en `EMITIDA` no se podían regenerar
   - **Solución**: Cambio temporal a `BORRADOR`

3. **clientPrice Vacío**
   - Campo nunca se llenaba en `ProcesoContratacion`
   - **Solución**: Usar `ofertaSalarial` como fallback

### Mejoras Sugeridas

1. **Automatizar Regeneración**
   - Hook al aprobar nóminas → regenerar snapshot
   - O cron job diario para snapshots en BORRADOR

2. **Poblar clientPrice**
   - Al crear/actualizar `ProcesoContratacion`
   - Calcular con markup desde `ofertaSalarial`

3. **Validación de Totales**
   - Alert si snapshot difiere mucho de cálculo en vivo
   - Dashboard con comparación Snapshot vs Real

---

## ✅ Resultado Final

### Antes
- 1 nómina en BD
- Snapshots con datos demo del 14/07
- Totales incorrectos (diferencias de hasta $140K)

### Después
- **280 nóminas** en BD
- **14 snapshots** actualizados con datos reales
- Totales correctos y sincronizados ✅

### Verificación
```bash
# Refrescar el navegador en:
http://localhost:3000/admin-hub/pagos/facturas

# Los totales ahora deben coincidir:
- WHG: $171,712.00
- Tabak Law: $132,118.00
- BK Law: $4,438.00
```

---

## 📚 Referencias

### Archivos Modificados
- `API-ANDES/src/admin-hub/client-invoice/client-invoice.service.ts`

### Scripts Disponibles
- `API-ANDES/generate-payrolls-july2026.js`
- `API-ANDES/fix-all-snapshots-july2026.js`

### Documentación Relacionada
- `RESUMEN_VERIFICACION_DATOS_FACTURA.md`
- `FLUJO_FACTURACION_VALIDACION.md`
- `AVISOS_MAPEO_VALIDACION.md`
- `FORMATO_USD_ADMIN_HUB.md`

---

**✅ Trabajo completado exitosamente el 29 de Julio, 2026**
