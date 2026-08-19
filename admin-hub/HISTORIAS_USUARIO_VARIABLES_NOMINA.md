# Historias de Usuario — Variables de Nómina (Admin Hub)

> **Scope:** Módulo "Variables de Nómina" del Admin Hub
> **Excluye:** Header, Sidebar, Breadcrumbs (ya tienen historias creadas)
> **Sprint:** 1 sprint · 3 historias de usuario
> **Figma File:** `Kj8pUV9UxH8CMxCzJhkKDs` — "Asistente Administrativa"
> **Nodos:** `187:3941` · `280:10000` · `226:6444` · `226:6872` · `209:6004` · `215:8405` · `215:8884` · `217:9701`

---

## [KAN-XX] Ver y explorar el listado de variables de nómina

**Como** administrador de nóminas,
**quiero** ver todas las variables de nómina en una tabla con filtros, búsqueda y exportación,
**para** tener visibilidad y control sobre las configuraciones activas del sistema.

**Criterios de aceptación:**
- [ ] La ruta `/nominas/variables-de-nomina` renderiza la página del módulo
- [ ] La tabla muestra: checkbox, nombre, categoría, código, estado (badge Activo/Inactivo), menú ⋮
- [ ] Hay 5 tabs: **Todos**, **Ausencias**, **Overtimes**, **Holidays**, **Deducciones** — al hacer clic se filtra la tabla y se refleja en la URL (`?categoria=...`)
- [ ] El input "Buscar" (320px, con ícono de lupa) filtra por nombre y código con debounce de 300ms
- [ ] El botón "Filtros" abre un panel con filtros adicionales (Estado, Categoría); muestra badge con cantidad de filtros activos
- [ ] El botón "Exportar" descarga un `.csv` con los datos actuales (respetando filtros); si hay rows seleccionadas, exporta solo esas
- [ ] La tabla soporta paginación (default 10 por página); el cambio de tab o filtro resetea a página 1
- [ ] Estado vacío: mensaje descriptivo + CTA para crear; estado de carga: skeleton loader; estado de error: mensaje + botón "Reintentar"

**Notas técnicas:**
- `GET /api/payroll-variables?page=1&limit=10&categoria=ausencias&search=...`
- `GET /api/payroll-variables/export?format=csv` (con mismos query params activos)
- Badge de estado: componente `StatesDesktop`; tabs: componente `Underline/Variables Nominas/ Desktop`
- Figma: `187:3941` (listado principal), `280:10000` (con selección activa)

**Story points:** 3

### Subtareas

- [ ] **[ST-1]** Crear ruta y layout base del módulo (`/nominas/variables-de-nomina`)
- [ ] **[ST-2]** Integrar endpoint `GET /api/payroll-variables` y renderizar tabla con paginación
- [ ] **[ST-3]** Implementar tabs de categoría con filtrado y reflejo en URL
- [ ] **[ST-4]** Implementar barra de búsqueda con debounce
- [ ] **[ST-5]** Implementar panel de filtros avanzados (Estado, Categoría)
- [ ] **[ST-6]** Implementar botón de exportación CSV
- [ ] **[ST-7]** Implementar checkboxes de selección múltiple (individual + select all)
- [ ] **[ST-8]** Implementar estados de carga (skeleton), vacío y error

---

## [KAN-XX] Crear, editar y eliminar variables de nómina

**Como** administrador de nóminas,
**quiero** crear nuevas variables de nómina y gestionar las existentes (editar y eliminar),
**para** mantener las configuraciones de nómina del sistema actualizadas.

**Criterios de aceptación:**

*Creación:*
- [ ] El botón "Crear" (ícono `plus`) en el toolbar navega a `/nominas/variables-de-nomina/crear`
- [ ] El formulario de creación se presenta en 4 pasos con indicador de progreso; el paso activo está resaltado
- [ ] **Paso 1 — Categoría:** cards seleccionables (Ausencia, Overtime, Holiday, Deducción); "Siguiente" se habilita solo con una seleccionada
- [ ] **Paso 2 — Datos básicos:** campos Nombre, Código (alfanumérico + guiones, sin espacios), Descripción; validación on-blur; campos obligatorios marcados con `*`
- [ ] **Paso 3 — Configuración de cálculo:** campos de tipo de monto, valor, periodicidad y aplicabilidad según la categoría; validación on-blur
- [ ] **Paso 4 — Revisión:** resumen de todos los datos por sección con link "Editar" a cada paso; botón "Crear variable" envía al API
- [ ] Navegar "Anterior" preserva los datos ya ingresados; "Cancelar" regresa al listado con confirmación modal si hay datos ingresados
- [ ] Creación exitosa: toast de éxito + redirige al listado; error (ej: código duplicado `409`): toast de error, permanece en el paso 4

*Edición:*
- [ ] El menú ⋮ de cada fila incluye la opción **Editar** (ícono `pen`); abre el mismo formulario pre-poblado con los datos actuales
- [ ] El CTA del paso 4 en modo edición dice "Guardar cambios"; al cambiar categoría se muestra advertencia de posible reseteo de campos
- [ ] Edición exitosa: toast de éxito + listado actualizado; error: toast de error sin pérdida de datos

*Eliminación:*
- [ ] El menú ⋮ incluye la opción **Eliminar** (ícono `trash-2`); muestra modal de confirmación con el nombre de la variable y botón "Eliminar" en rojo (`#E33434`)
- [ ] Al confirmar, la fila desaparece sin recargar la página; error: mensaje descriptivo en el modal sin cerrarlo
- [ ] **Eliminar en lote:** al seleccionar ≥1 row aparece barra de acciones con "Eliminar seleccionados"; misma confirmación modal con conteo ("X variables seleccionadas")

**Notas técnicas:**
- `POST /api/payroll-variables` (creación) · `PATCH /api/payroll-variables/:id` (edición)
- `DELETE /api/payroll-variables/:id` (individual) · `DELETE /api/payroll-variables` con `{ ids: [...] }` (lote)
- Campos inválidos: borde rojo `#E33434` + error inline; card seleccionada: color primario `#0097B2`
- Figma: `209:6004` (paso 1) · `215:8405` (paso 2) · `215:8884` (paso 3) · `217:9701` (paso 4) · `226:6444` (acciones lote) · `226:6872` (acciones individuales)

**Story points:** 8

### Subtareas

- [ ] **[ST-1]** Crear ruta `/nominas/variables-de-nomina/crear` con layout y stepper de progreso
- [ ] **[ST-2]** Implementar paso 1: cards de categoría con estado activo/inactivo
- [ ] **[ST-3]** Implementar paso 2: formulario de datos básicos con validación
- [ ] **[ST-4]** Implementar paso 3: formulario de configuración de cálculo por categoría
- [ ] **[ST-5]** Implementar paso 4: pantalla de revisión con links de edición por sección
- [ ] **[ST-6]** Gestión de estado del formulario multi-paso (persistencia entre pasos, modo creación/edición)
- [ ] **[ST-7]** Integrar `POST` y `PATCH` al API y manejar respuestas (éxito / errores)
- [ ] **[ST-8]** Implementar menú ⋮ por fila con opciones Editar y Eliminar
- [ ] **[ST-9]** Implementar modal de confirmación de eliminación (individual y en lote)
- [ ] **[ST-10]** Integrar `DELETE` individual y en lote; actualizar tabla sin recarga

---

## Resumen

| Historia | Story Points | Subtareas |
|----------|-------------|-----------|
| Ver y explorar listado | 3 pts | 8 |
| Crear, editar y eliminar | 8 pts | 10 |
| **Total** | **11 pts** | **18** |