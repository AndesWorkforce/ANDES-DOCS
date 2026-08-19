# Presentación: Nuevas Funcionalidades de Facturación en Admin Hub

**Duración:** 10 minutos  
**Audiencia:** Equipo de Administración  
**Objetivo:** Demostrar el nuevo flujo de gestión de facturas, cargos y créditos

---

## 📊 Estructura de la Presentación (10 min)

### 1. INTRODUCCIÓN (1 minuto)
**Slide 1: Portada**
- Título: "Nuevo Sistema de Facturación - Admin Hub"
- Subtítulo: "Gestión completa de facturas, cargos y créditos a clientes"

**Slide 2: Contexto**
- **Antes:** Facturación básica solo con nóminas
- **Ahora:** Facturación completa con cargos adicionales, descuentos y control de estados

---

### 2. TOUR GUIADO: 4 FUNCIONALIDADES PRINCIPALES (6-7 minutos)

#### 📋 Funcionalidad 1: Ver Detalle de Factura (1.5 min)

**Slide 3: Pantalla de Detalle de Factura**

**QUÉ VER:**
- ✅ Información del cliente (nombre, país, contacto)
- ✅ **5 pestañas organizadas:**
  1. **Nóminas** - Salarios y variables de empleados
  2. **Adicionales** - Gastos varios
  3. **Cargos al cliente** - Cobros extra (equipos, eventos)
  4. **Créditos al cliente** - Descuentos y ajustes
  5. **Alertas** - Avisos importantes del sistema
- ✅ **Total de factura** - Calculado automáticamente

**DEMOSTRACIÓN:**
```
"Como pueden ver, ahora tenemos toda la información organizada en pestañas.
En la pestaña de Nóminas vemos los $2,547.60 de salarios.
En Cargos al cliente vemos $50.00 por equipamiento.
Y en Créditos vemos -$100.00 de descuento por ausencia."
```

---

#### 💰 Funcionalidad 2: Agregar Cargos al Cliente (1.5 min)

**Slide 4: Crear Cargo al Cliente**

**CUÁNDO USAR:**
- Cliente solicitó equipos adicionales
- Se organizó un team building
- Se realizó una capacitación especial
- Cualquier cobro extra fuera de nómina

**CÓMO HACERLO:**
1. Click en **"Crear ítem"** (botón azul arriba a la derecha)
2. Seleccionar **"Cargos al cliente"**
3. Llenar el formulario:
   - **Tipo:** Team Building / Equipamiento / Capacitación / Otro
   - **Descripción:** "Laptops para 3 empleados nuevos"
   - **Monto:** $4,500
   - **Moneda:** USD
4. Click en **"Crear movimiento"**
5. ✅ El cargo aparece con estado **"Pendiente"**

**DEMOSTRACIÓN:**
```
"Imaginen que el cliente nos pidió 3 laptops. 
Simplemente creamos un cargo de tipo 'Equipamiento', 
ponemos la descripción y el monto, y listo.
El cargo queda registrado como pendiente."
```

**NOTA IMPORTANTE:**
⚠️ Los cargos pendientes **NO afectan el total** hasta que sean aprobados.

---

#### 💸 Funcionalidad 3: Agregar Créditos (Descuentos) (1.5 min)

**Slide 5: Crear Crédito al Cliente**

**CUÁNDO USAR:**
- Empleado renunció a mitad de mes
- Se aplicó descuento por días libres sin pago
- Ausencias no justificadas
- Cualquier ajuste o corrección

**CÓMO HACERLO:**
1. Click en **"Crear ítem"**
2. Seleccionar **"Créditos al cliente"**
3. Llenar el formulario:
   - **Tipo:** Renuncia / Deducción días libres / Ausencia / Ajuste manual
   - **Descripción:** "Renuncia empleado - 15 días pendientes"
   - **Monto:** $1,200 (se mostrará como **-$1,200.00**)
   - **Moneda:** USD
4. Click en **"Crear movimiento"**
5. ✅ El crédito aparece con estado **"Pendiente"** y monto **negativo**

**DEMOSTRACIÓN:**
```
"Si un empleado renunció el día 15 y solo trabajó media quincena,
creamos un crédito de tipo 'Renuncia' por los días no trabajados.
El sistema lo muestra como monto negativo, que se resta del total."
```

**NOTA IMPORTANTE:**
⚠️ Los créditos pendientes **NO afectan el total** hasta que sean aprobados.

---

#### ✅ Funcionalidad 4: Aprobar y Emitir Factura (2 min)

**Slide 6: Proceso de Aprobación**

**FLUJO COMPLETO:**

**Paso 1: Revisar todos los items**
- Ir pestaña por pestaña
- Verificar que nóminas estén correctas
- Verificar que cargos y créditos sean válidos

**Paso 2: Aprobar items pendientes**
- Click en el menú de 3 puntos (...) de cada item
- Seleccionar **"Aprobar"**
- ✅ El estado cambia a **"Aprobado"**
- El item ahora cuenta para el total

**Paso 3: Emitir la factura**
- Cuando **todos** los items estén aprobados
- Click en **"Emitir Invoice"** (botón verde)
- El sistema:
  - ✅ Calcula el total final
  - ✅ Genera el snapshot definitivo
  - ✅ Cambia estado a **"Emitida"**

**DEMOSTRACIÓN:**
```
"Después de revisar todo, aprobamos cada cargo y crédito.
Vean cómo el estado cambia a 'Aprobado'.
Cuando todo está correcto, hacemos click en 'Emitir Invoice'
y el sistema genera la factura oficial con el total definitivo."
```

---

**Slide 7: Estados de la Factura**

**FLUJO DE ESTADOS:**

```
📝 BORRADOR (Editable)
    ↓
    [Emitir Invoice]
    ↓
📄 EMITIDA (No editable, oficial)
    ↓
    [Marcar como pagada]
    ↓
✅ PAGADA (Factura cobrada)
```

**QUÉ SIGNIFICA CADA ESTADO:**

**📝 BORRADOR:**
- Puedes agregar/modificar cargos y créditos
- Puedes aprobar/rechazar items
- El total se recalcula al emitir

**📄 EMITIDA:**
- Factura oficial y formalizada
- **NO se puede editar**
- Lista para enviar al cliente
- Esperando pago

**✅ PAGADA:**
- Cliente pagó la factura
- Proceso cerrado

---

### 3. CASOS DE USO PRÁCTICOS (1-2 minutos)

**Slide 8: Casos de Uso Reales**

#### Caso 1: Renuncia de Empleado 🚪
**Situación:** María renunció el 15 de julio. Solo trabajó 10 días.

**Qué hacer:**
1. Ir a la factura de julio del cliente
2. Crear **Crédito** tipo "Renuncia"
3. Calcular: (Salario mensual / 20 días) × 10 días no trabajados
4. Aprobar el crédito
5. Emitir factura con el ajuste

**Resultado:** Cliente paga solo por los 10 días trabajados ✅

---

#### Caso 2: Team Building 🎉
**Situación:** Cliente organizó evento de team building y pidió facturarlo.

**Qué hacer:**
1. Ir a la factura del mes actual
2. Crear **Cargo** tipo "Team Building"
3. Agregar descripción: "Evento team building - 20 empleados"
4. Monto: $2,500
5. Aprobar el cargo
6. Emitir factura con el cargo adicional

**Resultado:** Cobro adicional de $2,500 incluido en la factura ✅

---

#### Caso 3: Equipamiento Nuevo 💻
**Situación:** Cliente solicitó laptops para 3 empleados nuevos.

**Qué hacer:**
1. Ir a la factura del mes
2. Crear **Cargo** tipo "Equipamiento"
3. Descripción: "3 laptops MacBook Pro"
4. Monto: $4,500
5. Aprobar el cargo
6. Emitir factura

**Resultado:** Equipos facturados correctamente al cliente ✅

---

#### Caso 4: Ausencia Sin Pago 🏥
**Situación:** Empleado faltó 3 días sin justificación médica.

**Qué hacer:**
1. Ir a la factura del mes
2. Crear **Crédito** tipo "Ausencia"
3. Calcular: (Salario mensual / 20 días) × 3 días
4. Aprobar el crédito
5. Emitir factura con descuento

**Resultado:** Cliente no paga por días no trabajados ✅

---

### 4. PUNTOS CLAVE PARA RECORDAR (1 minuto)

**Slide 9: Mejores Prácticas**

#### ✅ HACER:
1. **Revisar todo antes de emitir** - Una vez emitida, NO se puede editar
2. **Aprobar items uno por uno** - Verificar cada cargo y crédito
3. **Describir claramente** - Facilita auditorías futuras
4. **Emitir al final del mes** - Cuando toda la información esté completa

#### ❌ EVITAR:
1. **Emitir con items pendientes** - El sistema lo bloqueará
2. **Emitir antes de tiempo** - Pueden faltar cargos o créditos
3. **Olvidar aprobar** - Items pendientes no afectan el total

---

**Slide 10: Ventajas del Nuevo Sistema**

#### 🎯 Beneficios para Administración:

**Antes:**
- ❌ Solo nóminas básicas
- ❌ Ajustes manuales fuera del sistema
- ❌ Sin control de cargos adicionales
- ❌ Difícil auditoría

**Ahora:**
- ✅ **Todo en un solo lugar** - Nóminas, cargos, créditos
- ✅ **Control total** - Aprobar/rechazar items
- ✅ **Trazabilidad completa** - Quién creó/aprobó cada item
- ✅ **Cálculo automático** - El sistema suma/resta todo
- ✅ **Proceso formal** - Estados claros (Borrador → Emitida → Pagada)

---

### 5. CIERRE Y PREGUNTAS (1 minuto)

**Slide 11: Resumen**

#### 📋 En Resumen:

**4 Funcionalidades Nuevas:**
1. ✅ Ver detalle completo de factura organizado
2. ✅ Agregar cargos al cliente
3. ✅ Agregar créditos (descuentos)
4. ✅ Aprobar y emitir factura formal

**Flujo Simplificado:**
```
1. Revisar nóminas
2. Agregar cargos/créditos necesarios
3. Aprobar todo
4. Emitir factura
5. Marcar como pagada cuando cliente pague
```

---

**Slide 12: Preguntas & Recursos**

**¿Preguntas?**

**Recursos Disponibles:**
- 📖 Manual de usuario (próximamente)
- 💬 Canal de Slack: #soporte-admin-hub
- 📧 Email: soporte@andesworkforce.com

**Próximos Pasos:**
- Acceso al sistema estará habilitado mañana
- Sesión de práctica opcional la próxima semana
- Soporte disponible durante las primeras semanas

---

## 🎨 Recomendaciones de Presentación

### Visual:
- **Slides limpios** con capturas de pantalla reales del sistema
- **Colores:** Azul para acciones principales, verde para éxito, rojo para alertas
- **Usar números grandes** para mostrar montos ($2,547.60, -$100.00)
- **Iconos:** 💰 para cargos, 💸 para créditos, ✅ para aprobados

### Demostración:
- **Screen sharing en vivo** es mejor que slides estáticos
- **Preparar datos de prueba** antes de la presentación
- **Tener 2-3 ejemplos listos** para crear durante la demo

### Narrativa:
- **Comenzar con un caso real** que todos conozcan
- **Usar nombres ficticios** pero situaciones reales
- **Enfatizar beneficios** no solo funcionalidades
- **Ser interactivo** - preguntar "¿Alguien ha tenido este caso?"

### Timing:
```
✅ Intro: 1 min
✅ Demo funcionalidades: 6-7 min
✅ Casos de uso: 1-2 min
✅ Cierre: 1 min
─────────────────────
   TOTAL: 10 min
```

---

## 📝 Script Sugerido para Cada Sección

### INICIO:
```
"Buenos días a todos. Hoy voy a mostrarles las nuevas funcionalidades 
de facturación en el Admin Hub. En 10 minutos veremos cómo estas 
herramientas simplificarán su trabajo diario de facturación.

Antes, solo podíamos facturar nóminas básicas. Cualquier cargo extra 
o descuento había que manejarlo fuera del sistema. 

Ahora, todo está integrado en un solo lugar."
```

### DURANTE LA DEMO:
```
"Como ven en pantalla, esta es una factura real de julio. 
Vean que aquí tenemos 5 pestañas organizadas...

Vamos a simular un caso real: imaginen que el cliente nos pidió 
3 laptops para empleados nuevos. Miren qué fácil es registrar esto..."

[Hacer la demostración en vivo]

"¿Ven? En 30 segundos creamos el cargo, y ahora está visible 
en la factura con estado pendiente."
```

### CIERRE:
```
"En resumen, ahora tienen el control total de la facturación 
desde el Admin Hub. Pueden agregar cargos, aplicar descuentos, 
y emitir facturas formales, todo en un solo lugar.

El acceso estará disponible desde mañana, y tendremos una sesión 
de práctica opcional la próxima semana para quien quiera.

¿Alguna pregunta?"
```

---

## ✅ Checklist Pre-Presentación

### Preparación Técnica:
- [ ] Sistema funcionando en ambiente demo
- [ ] Datos de prueba cargados (factura con nóminas)
- [ ] Browser abierto en la página correcta
- [ ] Zoom/proyector configurado correctamente
- [ ] Audio y video funcionando

### Preparación de Contenido:
- [ ] Slides listos y revisados
- [ ] Script repasado (timing de 10 min)
- [ ] 2-3 ejemplos preparados para crear
- [ ] Casos de uso impresos (backup si falla la demo)

### Durante la Presentación:
- [ ] Hablar despacio y claro
- [ ] Pausar para preguntas
- [ ] Mostrar beneficios, no solo features
- [ ] Usar lenguaje no técnico
- [ ] Ser entusiasta pero realista

---

**¡Éxito en la presentación!** 🚀
