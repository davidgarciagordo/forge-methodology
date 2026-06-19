[English](README.md) | **Español**

# Forge — Ejemplos de uso

> Prompts listos para copiar y pegar que muestran cómo invocar Forge en distintos tipos de tarea y dominio.

Estos son prompts reales — pégalos en tu asistente de IA para iniciar una sesión Forge. Cada ejemplo muestra qué produce Forge, qué lentes de grill se aplican y qué significa "hecho" para ese dominio.

---

## Estilos de prompt

Forge funciona tanto con prompts cortos como con prompts estructurados:

**Corto** — contexto mínimo, Forge conduce el paso de alineación:

```
Pasa esto por la Forge: añade webhooks de pago idempotentes a nuestro servicio de checkout.
```

**Estructurado** — proporciona contexto, restricciones y definición de done desde el inicio:

```
Pasa esto por la Forge.

Tarea: añadir webhooks de pago idempotentes a nuestro servicio de checkout
Contexto: API Node.js/Express, PostgreSQL, eventos de Stripe
Restricciones: despliegue sin tiempo de inactividad; la lógica de reintentos de Stripe
no debe provocar cargos duplicados
Definición de done: el endpoint gestiona reintentos de forma idempotente, todos los
tipos de evento de Stripe que usamos están cubiertos, los tests de integración pasan,
el checklist de seguridad está despejado
```

Ambos funcionan. El formato estructurado comprime el paso de alineación porque ya has respondido la pregunta de valor. El formato corto deja que Forge plantee primero las preguntas de alineación.

---

## 1. Funcionalidad backend — Webhooks de pago idempotentes

**Pack de dominio:** [software-backend](../references/domain-packs/software-backend.md)

### Prompt corto

```
Pasa esto por la Forge: añade webhooks de pago idempotentes a nuestro servicio de checkout.
```

### Prompt estructurado

```
Pasa esto por la Forge.

Tarea: añadir webhooks de pago idempotentes a nuestro servicio de checkout
Contexto: API Node.js/Express, PostgreSQL, Stripe; ~500 eventos de webhook/día; el
handler actual no comprueba la clave de idempotencia
Restricciones: despliegue sin tiempo de inactividad; Stripe reintenta eventos fallidos
hasta 3×; no debe producir cargos duplicados ni decrementos de inventario dobles
Definición de done: clave de idempotencia almacenada y comprobada en cada evento, el
handler es seguro ante reintentos, todos los tipos de evento de Stripe que usamos están
cubiertos, los tests de integración pasan, el checklist de seguridad está despejado,
sin consultas N+1 introducidas
```

### Qué hace Forge con esto

- **Spec producido:** documento versionado que define el esquema de la clave de idempotencia, la estrategia de almacenamiento (tabla dedicada o capa de caché), los tipos de evento en scope, el tratamiento de errores para duplicados vs. replay genuino, y el contrato de API del endpoint de webhook.
- **Grill — lente de Arquitecto de plataforma:** lee el código del handler existente, comprueba si ya existe un wrapper de transacción en la base de código, identifica los bounded contexts afectados (pedidos, inventario, facturación) y señala cualquier índice faltante en la columna de clave de idempotencia.
- **Grill — lente de Operador real:** somete a prueba el spec contra el caso de Stripe reintentando tras un commit parcial, un timeout de red en mitad del handler y un operador reproduciendo manualmente un evento para resolver un problema de soporte — los casos que nunca aparecen en el camino feliz.
- **Grill — lente de Ingeniero del dominio:** comprueba condiciones de carrera cuando dos reintentos de Stripe llegan con milisegundos de diferencia, verifica el nivel de aislamiento de la transacción y señala si la comprobación de idempotencia y la acción de negocio están dentro del mismo límite transaccional.
- **Definición de done:** typecheck en verde, suite completa en verde (no solo el módulo de webhook), los tests de integración cubren los escenarios de reintento, el checklist de seguridad está despejado, sin regresiones respecto a la línea base.

---

## 2. Frontend / UI — Rediseño del flujo de incorporación

**Pack de dominio:** [software-frontend](../references/domain-packs/software-frontend.md)

### Prompt

```
Pasa esto por la Forge.

Tarea: rediseñar el flujo de incorporación para usuarios nuevos
Contexto: app React, Tailwind CSS con nuestra capa de tokens de diseño personalizada;
el flujo actual tiene un abandono del ~65% en el paso 3 de 5; el 70% del tráfico
proviene de móviles
Restricciones: deben usarse los tokens de diseño existentes; sin nuevas dependencias;
el flujo debe funcionar en conexiones 3G lentas
Definición de done: abandono reducido de forma medible; flujo verificado en móvil en
todos los breakpoints; modos claro/oscuro correctos; navegación por teclado y salida de
lector de pantalla pasan la auditoría de accesibilidad; stories de componente creadas
para cada componente nuevo
```

### Qué hace Forge con esto

- **Spec producido:** un informe de decisión que concreta cuál es la causa real del abandono (a partir de analíticas, no por suposición), qué cubre el flujo rediseñado en cada paso, qué componentes se reutilizan frente a cuáles son nuevos, y qué significa "abandono reducido" en términos medibles y verificables antes de mover un píxel.
- **Grill — lente de UX/Usuario:** cuestiona si el paso 3 es la causa o un síntoma, solicita los desgloses de analíticas por dispositivo, idioma y fuente de tráfico, y prueba el spec ante el caso de un usuario que retoma la incorporación en mitad desde un dispositivo diferente.
- **Grill — lente de Accesibilidad:** señala cualquier paso que dependa únicamente de estados hover, comprueba la gestión del foco al avanzar entre pasos, y verifica que el indicador de progreso se anuncia correctamente a los lectores de pantalla.
- **Grill — lente de Sistema de diseño:** comprueba si el rediseño usa los tokens y componentes existentes o introduce silenciosamente valores codificados, y señala cualquier superficie donde el nuevo flujo rompa en modo oscuro o en el breakpoint más pequeño definido.
- **Definición de done:** gate visual superado (capturas de cada paso en claro/oscuro × móvil/tablet/escritorio), auditoría de accesibilidad superada, stories de componente fusionadas, métrica de abandono medible antes y después — no se declara reducida sin datos.

---

## 3. Auditoría de seguridad — Autenticación y gestión de sesiones

**Pack de dominio:** [security](../references/domain-packs/security.md)

### Prompt

```
Pasa esto por la Forge.

Tarea: auditar nuestra autenticación y gestión de sesiones de extremo a extremo
Contexto: auth basada en JWT, refresh tokens almacenados en cookies httpOnly, backend
Node.js/Express, PostgreSQL; nos aproximamos a una auditoría SOC 2 Tipo II
Restricciones: debe cubrir tanto el código como la configuración de infraestructura;
los hallazgos deben ser accionables y clasificados por severidad
Definición de done: todos los ítems del OWASP Top 10 comprobados, cada hallazgo
bloqueante tiene un plan de remediación con responsable y fecha, el checklist de
controles SOC 2 para autenticación completado, el runbook de respuesta a incidentes
actualizado
```

### Qué hace Forge con esto

- **Spec producido:** un modelo de amenazas acotado a la superficie de autenticación — puntos de entrada, límites de confianza, ciclo de vida del token (emisión, refresco, rotación, revocación), rutas de invalidación de sesión, y los controles SOC 2 que se mapean a cada componente.
- **Grill — lente de Atacante:** intenta explotar la superficie de autenticación: ataques de confusión de algoritmo JWT, replay de refresh token tras cierre de sesión, fijación de sesión, escalada de privilegios mediante manipulación de claims, y abuso del flujo "olvidé mi contraseña" como canal lateral de enumeración de cuentas.
- **Grill — lente de Defensor/Respondedor de incidentes:** pregunta qué alertas se disparan cuando un token es robado y reproducido, cuál es el radio de explosión si la clave de firma se filtra, con qué rapidez pueden invalidarse sesiones en todos los dispositivos activos, y si el registro de auditoría captura suficiente información para reconstruir la línea temporal de un incidente completo.
- **Grill — lente de Cumplimiento/Auditoría:** mapea cada control a la familia de controles SOC 2 CC6 (acceso lógico), comprueba la evidencia requerida (registros de acceso, registros de aprovisionamiento, procedimientos de revocación) y señala lo que los auditores pedirán que aún no está documentado ni automatizado.
- **Definición de done:** todos los hallazgos clasificados por severidad y asignados a responsables, OWASP Top 10 completamente resuelto, paquete de evidencias SOC 2 ensamblado, runbook de respuesta a incidentes actualizado, sin secretos en el historial de versiones.

---

## 4. Decisión de producto — App nativa vs. PWA

**Pack de dominio:** [brainstorming](../references/domain-packs/brainstorming.md)

### Prompt

```
Pasa esto por la Forge.

Tarea: decidir si construir una app móvil nativa o una PWA para nuestra próxima fase
de producto
Contexto: SaaS B2B, ~2.000 usuarios, el 60% accede por móvil para consultar
dashboards y notificaciones; equipo de ingeniería de 4 personas con experiencia en
React y sin experiencia en móvil nativo; 6 meses de runway hasta la próxima ronda
de financiación
Restricciones: la capacidad del equipo es fija; no podemos contratar desarrolladores
nativos en este ciclo; la decisión debe tomarse esta semana para desbloquear la
planificación del roadmap
Definición de done: informe de decisión escrito con la opción elegida, suposiciones
explícitas, criterios de evaluación usados, y el argumento contrario más sólido a la
opción elegida documentado y respondido
```

### Qué hace Forge con esto

- **Spec producido:** un informe de decisión con el marco de decisión (qué estamos eligiendo y por qué importa ahora), criterios de evaluación clasificados por importancia (calidad de experiencia de usuario, velocidad de entrega, capacidad del equipo, coste, soporte offline, dependencias de tiendas de aplicaciones), opciones con suposiciones explícitas por opción, y las restricciones que descartan opciones.
- **Grill — lente de Crítico:** cuestiona la suposición de que el 60% de uso móvil implica necesidad de características nativas, pregunta si "consultar dashboards" requiere algo más que una app web responsive bien optimizada, y examina si la restricción de 6 meses es un plazo real o una preferencia flexible.
- **Grill — lente de Visión alternativa:** argumenta el caso más sólido para la opción no elegida, saca a la luz la opción "no construir nada nuevo y optimizar la app web existente" que probablemente no se generó, y pregunta qué aprendieron equipos que tomaron el otro camino.
- **Grill — lente de Viabilidad:** modela lo que realmente implicaría lanzar una app nativa — plazos de envío a App Store y Play Store, ciclos de revisión, gestión de certificados, configuración de notificaciones push, manejo de deep links — y compara cada elemento con el equivalente en PWA. Señala los costes ocultos que no aparecen en la estimación inicial.
- **Definición de done:** informe de decisión escrito y guardado en el repositorio, opción elegida documentada con todas las suposiciones clave marcadas como verificadas o no verificadas, argumento contrario más sólido reconocido y respondido, próximos pasos específicos con responsable asignado — no "exploraremos la opción A."

---

## 5. Marketing — Campaña de lanzamiento de producto

**Pack de dominio:** [marketing](../references/domain-packs/marketing.md)

### Prompt

```
Pasa esto por la Forge.

Tarea: planificar la campaña de lanzamiento de nuestro nuevo producto de automatización
de facturas
Contexto: SaaS B2B dirigido a equipos de finanzas en empresas medianas (50–500
empleados); el producto reduce el tiempo de procesamiento de facturas en un ~70%;
lanzamiento en 6 semanas; presupuesto de 15.000 €
Restricciones: sin redes sociales de pago; canales principales son email, LinkedIn
orgánico y un lanzamiento en Product Hunt; tenemos 3 casos de estudio de clientes
disponibles
Definición de done: brief de campaña con mensajes, plan por canal, lista de activos,
métricas de éxito definidas antes del lanzamiento (no después), revisión legal/de
cumplimiento completada
```

### Qué hace Forge con esto

- **Spec producido:** un brief de campaña con el mensaje principal, el plan por canal, los requisitos de activos, el calendario y las métricas de éxito definidas antes del lanzamiento — no a posteriori. Incluye las suposiciones clave sobre el comportamiento actual y el dolor principal de la audiencia objetivo, enunciadas explícitamente para que puedan verificarse.
- **Grill — lente de Cliente/Audiencia:** comprueba si "reduce el tiempo de procesamiento en un 70%" es el mensaje al que realmente responden los equipos de finanzas de empresas medianas, o si el dolor real es la tasa de errores, el riesgo en auditorías o la presión de cierre de mes — y pregunta cuál de los tres casos de estudio se mapea mejor al problema principal de la audiencia.
- **Grill — lente de Escéptico:** pregunta por qué un equipo de finanzas cambiaría su proceso actual, qué hace bien la solución actual que este producto no hace, y si la audiencia de Product Hunt es el comprador real o un público técnico adyacente que no va a convertir.
- **Grill — lente de Marca/Legal:** comprueba si la afirmación del "70% de reducción" está verificada y es defendible con los datos de los casos de estudio, señala las divulgaciones requeridas (estándares publicitarios, cualquier afirmación financiera) y verifica que los textos de LinkedIn y email encajan con la voz de marca establecida.
- **Definición de done:** todas las afirmaciones sustentadas con evidencia, validación de audiencia completada (mínimo: una entrevista con un cliente), métricas definidas y medibles antes del lanzamiento, revisión legal realizada, todos los activos formateados correctamente según las especificaciones de cada canal.

---

## 6. Finanzas — Modelo de ingresos y flujo de caja a 3 años

**Pack de dominio:** [finance](../references/domain-packs/finance.md)

### Prompt

```
Pasa esto por la Forge.

Tarea: construir un modelo de ingresos y flujo de caja a 3 años para apoyar una ronda
de financiación Serie A
Contexto: SaaS B2B, suscripciones mensuales, ARR actual 480.000 €, 3 niveles de
precio; churn mensual ~2%; objetivo de financiación 3M€; los inversores someterán el
modelo a pruebas de estrés
Restricciones: debe incluir escenarios base, pesimista y optimista; todas las
suposiciones deben estar documentadas con fuentes; el formato debe ser apto para
inversores
Definición de done: el modelo cuadra con las cifras reales actuales, el análisis de
sensibilidad cubre los inputs clave (churn, crecimiento de nuevos clientes, ingresos
de expansión), revisión independiente de nuestro asesor CFO completada, sin valores
codificados en fórmulas
```

### Qué hace Forge con esto

- **Spec producido:** un brief del modelo que define el formato de salida (mensual/trimestral/anual), las métricas clave a modelar (cascada de MRR: nuevos, expansión, contracción, churn), las suposiciones de entrada a parametrizar y los escenarios a probar — antes de comenzar la construcción.
- **Grill — lente de Auditor:** comprueba si el modelo cuadra con las cifras reales actuales, verifica la tasa de churn (2% mensual = ~22% anual) contra datos de cohortes reales en lugar de un número declarado, y señala cualquier suposición que sea un número redondo sin fuente documentada.
- **Grill — lente de Analista de riesgos:** somete a prueba el escenario pesimista: ¿qué ocurre si el churn se duplica, el crecimiento de nuevos clientes se reduce a la mitad y la financiación tarda 6 meses más de lo previsto? Modela la fecha de agotamiento de caja en el escenario pesimista y señala si los 3M€ son suficientes dado ese riesgo.
- **Grill — lente de Stakeholder/Decisor:** pregunta si el modelo responde la pregunta concreta que harán los inversores ("¿cuándo alcanzáis flujo de caja positivo?"), comprueba si las suposiciones de ingresos de expansión están respaldadas por datos de comportamiento de clientes existentes, y verifica que el formato de salida apoya una decisión en lugar de simplemente mostrar números.
- **Definición de done:** el modelo cuadra con las cifras reales actuales, análisis de sensibilidad completo en tres escenarios, todos los inputs documentados con fuente y fecha, revisión independiente del asesor CFO superada, sin valores codificados, todos los escenarios claramente etiquetados.

---

## 7. Migración de datos — MySQL a PostgreSQL sin tiempo de inactividad

**Packs de dominio:** [software-backend](../references/domain-packs/software-backend.md) · [software-agents](../references/domain-packs/software-agents.md)

### Prompt

```
Pasa esto por la Forge.

Tarea: migrar nuestra base de datos de producción de MySQL a PostgreSQL sin tiempo
de inactividad
Contexto: 15 tablas, ~8M filas, 3 servicios leen y escriben en esta base de datos;
desplegados en AWS; MySQL 5.7; tráfico pico de 08:00 a 22:00 UTC; ventana de bajo
tráfico de 02:00 a 06:00 UTC
Restricciones: cero pérdida de datos; la aplicación debe permanecer disponible durante
la migración; el rollback debe ser posible en 15 minutos ante cualquier fallo; la
complejidad de escritura dual no puede superar las 2 horas
Definición de done: paridad de datos verificada en una muestra representativa, los 3
servicios probados contra Postgres en staging, la migración completada en la ventana
de bajo tráfico, el procedimiento de rollback probado antes de la noche de migración,
cero errores en la ventana de monitoreo de 24h posteriores
```

### Qué hace Forge con esto

- **Spec producido:** un spec de migración que define la estrategia de escritura dual, la secuencia de migración (con pasos exactos y responsable por paso), las condiciones de activación del rollback y los puntos de decisión, el método de verificación de paridad de datos (conteo de filas + checksum) y los criterios de go/no-go para cada fase.
- **Grill — lente de Arquitecto de plataforma:** lee el esquema existente y señala incompatibilidades con PostgreSQL (tipos específicos de MySQL, `AUTO_INCREMENT` vs. secuencias, `TINYINT(1)` para booleanos, diferencias en el manejo de JSON), escanea los 3 servicios en busca de cadenas SQL que fallarán en Postgres e identifica los servicios que usan funciones específicas de MySQL.
- **Grill — lente de Operador real:** somete a prueba la secuencia de migración ante el escenario donde uno de los 3 servicios no puede redistribuirse dentro de la ventana de mantenimiento, pregunta qué ocurre con las escrituras que llegan durante la ventana de cambio de DNS, y prueba el procedimiento de rollback ante el caso en que las dos bases de datos ya han divergido.
- **Grill — lente de Ingeniero del dominio:** comprueba las diferencias de aislamiento de transacciones entre MySQL y Postgres que podrían afectar al comportamiento de la aplicación, señala el bloqueo a nivel de aplicación que asume la semántica de bloqueo de MySQL, y verifica que la ventana de escritura dual gestiona los conflictos cuando ambas bases de datos reciben escrituras en competencia.
- **Ejecución:** workers paralelos con propiedad de ficheros disjunta — traducción de esquema, parches de compatibilidad de servicios, scripts de verificación de paridad, validación en staging — cada uno en su propia rama aislada. Los workers hacen commit al final de cada fase; un fallo en cualquier fase se retoma desde el último checkpoint, no desde cero.
- **Definición de done:** paridad de conteo de filas y checksum verificada, los 3 servicios probados contra Postgres en staging, procedimiento de rollback probado antes de la noche de migración, ventana de monitoreo de 24h superada sin errores.

---

## 8. Investigación y análisis — Evaluación de proveedores

**Referencia de dominio:** [the-loop.md](../references/the-loop.md) (bucle genérico — no se necesita pack dedicado)

### Prompt

```
Pasa esto por la Forge.

Tarea: evaluar tres proveedores de infraestructura de búsqueda y recomendar uno
Contexto: reemplazamos nuestro clúster de Elasticsearch autogestionado; los candidatos
son Algolia, Typesense y un clúster OpenSearch autogestionado actualizado; el índice
tiene ~12M documentos, volumen de consultas pico de ~800 req/s; el equipo no tiene
experiencia en operaciones de Elasticsearch
Restricciones: decisión en 2 semanas; migración completable en un trimestre; techo
de coste de 3.000 €/mes
Definición de done: evaluación escrita con puntuación según criterios definidos, todas
las suposiciones clave verificadas (no afirmadas), el argumento contrario más sólido
a la opción recomendada documentado, decisión suficientemente concreta para actuar
inmediatamente
```

### Qué hace Forge con esto

- **Spec producido:** un brief de investigación que concreta los criterios de evaluación (latencia de consultas a escala, throughput de indexación, carga operativa, coste, complejidad de migración, riesgo de dependencia del proveedor), sus pesos relativos y el método de verificación para cada uno — antes de investigar ningún proveedor.
- **Grill — lente de Metodología:** comprueba si los criterios son medibles y verificables, pregunta si los 800 req/s son el pico o la media sostenida, y cuestiona si "sin experiencia en operaciones" es una restricción que aplica a las tres opciones o solo a la autogestionada.
- **Grill — lente de Experto del dominio:** pregunta cuál es la línea base de rendimiento real de Elasticsearch actual (no solo "es lento"), si el índice de 12M documentos tiene los patrones de consulta (facetado, geo, tolerancia a errores tipográficos) que diferencian materialmente a los proveedores, y qué datos de experiencia de migración de equipos que han hecho este cambio están disponibles públicamente.
- **Grill — lente de Reproducibilidad:** comprueba que las recomendaciones de los proveedores son verificables de forma independiente (precios públicos, benchmarks reproducibles, guías de migración existentes), señala cualquier afirmación que descanse únicamente en benchmarks proporcionados por el propio proveedor, y verifica que la estimación de costes tiene en cuenta las operaciones de indexación y la transferencia de datos — no solo el volumen de consultas.
- **Definición de done:** evaluación escrita guardada en el repositorio, todas las suposiciones clave marcadas como verificadas con fuente citada, la recomendación es específica (nombra al proveedor, indica el enfoque de migración, identifica las tres primeras acciones), el argumento contrario más sólido reconocido y respondido.

---

## Resumen

| # | Tarea | Pack de dominio |
|---|-------|-----------------|
| 1 | Webhooks de pago idempotentes | [software-backend](../references/domain-packs/software-backend.md) |
| 2 | Rediseño del flujo de incorporación | [software-frontend](../references/domain-packs/software-frontend.md) |
| 3 | Auditoría de seguridad de auth y sesiones | [security](../references/domain-packs/security.md) |
| 4 | Decisión app nativa vs. PWA | [brainstorming](../references/domain-packs/brainstorming.md) |
| 5 | Campaña de lanzamiento de producto | [marketing](../references/domain-packs/marketing.md) |
| 6 | Modelo de ingresos y flujo de caja a 3 años | [finance](../references/domain-packs/finance.md) |
| 7 | Migración MySQL → PostgreSQL sin tiempo de inactividad | [software-backend](../references/domain-packs/software-backend.md) · [software-agents](../references/domain-packs/software-agents.md) |
| 8 | Evaluación de proveedores y recomendación | [the-loop](../references/the-loop.md) |

→ Volver a [Metodología Forge](../README.md)
