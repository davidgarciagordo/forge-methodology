[English](README.md) | **Español**

# 🔨 Metodología Forge

[![Claude Code plugin](https://img.shields.io/badge/Claude_Code-plugin-D97757)](https://github.com/davidgarciagordo/claude-code-setup-optimizer) [![skills.sh](https://img.shields.io/badge/skills.sh-skill-111111)](https://skills.sh) ![License MIT](https://img.shields.io/badge/license-MIT-2da44e) ![Version](https://img.shields.io/badge/version-1.0.0-blue)

> Una metodología disciplinada para trabajo sustancial con IA — cualquier dominio, cualquier tipo de tarea.

### 🧩 Parte de una familia — misma firma, tres repos

| | Repo | Rol |
|---|---|---|
| 🛠️ | [**claude-code-setup-optimizer**](https://github.com/davidgarciagordo/claude-code-setup-optimizer) | **El hub** — metodología + automatizaciones (hooks · subagents · comandos) + `/optimize-my-setup` |
| 🔨 | [**forge-methodology**](https://github.com/davidgarciagordo/forge-methodology) · *estás aquí* | Estructura *qué construir* — alinear → spec → grill ×3 → plan → verificar |
| 🎨 | [**design-review**](https://github.com/davidgarciagordo/design-review) | Pule *cómo se ve* — estructura → auditoría → anti-slop → a11y → check en vivo |

## 📦 Instalación

```bash
# 🟢 Como skill (Claude Code + 20+ agentes vía skills.sh)
npx skills add davidgarciagordo/forge-methodology

# 🔌 Como plugin de Claude Code (suelto)
/plugin marketplace add davidgarciagordo/forge-methodology
/plugin install forge-methodology@forge-methodology

# 🛠️ O todos los repos desde el hub
/plugin marketplace add davidgarciagordo/claude-code-setup-optimizer
```

**Forge** es un flujo de trabajo con nombre propio para la colaboración persona↔IA. Estructura cualquier trabajo demasiado importante para improvisar: nuevas funcionalidades, decisiones arquitectónicas, análisis de seguridad, campañas de marketing, modelos financieros, proyectos de investigación. La versión corta: **alinear intención → descomponer la referencia → spec (con Matriz de Aceptación) → grill adversarial → plan global → ejecución optimizada → verificado → aprobación del responsable**.

> **Lo que hace que "hecho" sea mecánico (no advisory).** El fallo más caro de Forge es entregar algo que
> pasaba sus propios tests pero se quedaba corto frente al objetivo — *"Hecho contra nosotros, no contra el
> objetivo"*. La **columna vertebral de completitud mecánica** lo cierra: **nombras una referencia externa y
> enumeras sus capacidades** (Descomposición de la Referencia), que **se convierten en una Matriz de
> Aceptación** que es la Definición de Hecho canónica en el spec; una **4ª lente del grill** caza lo que
> *falta* (no solo lo que rompe); un **verificador independiente** audita cada fila (`verified-by ≠ ejecutor`);
> y un **hook bloquea abrir el PR** mientras una fila in-scope no esté trazada. **GREEN ≠ COMPLETE.**

Forge no es un proceso para todo. Las líneas sueltas y el formateo van directo. Forge es para el trabajo donde equivocarse en el diseño resulta caro — porque los agentes de IA son rápidos, y ejecutar lo incorrecto a toda velocidad es una forma eficiente de desperdiciar mucho esfuerzo.

---

## ¿Por qué Forge?

Los agentes de IA son rápidos. Esa velocidad también es un riesgo: ejecutarán lo incorrecto a fondo. Forge adelanta el pensamiento difícil para que la ejecución sea mecánica:

- La **intención alineada** detecta desajustes entre lo que se pidió y lo que realmente se necesita — antes de comenzar cualquier trabajo
- El **spec versionado** crea un contrato escrito en el que persona e IA están de acuerdo
- El **grill adversarial** detecta suposiciones erróneas antes de que queden integradas en los entregables
- El **plan global** elimina la improvisación durante la ejecución y las condiciones de carrera entre workers paralelos
- El **modelo-por-tarea** mantiene el coste proporcional a la dificultad
- El **verify continuo por unidad** detecta defectos en la fase N, no en la revisión de la fase N+10

---

## Por qué Forge — con y sin

| | Sin Forge | Con Forge |
|---|---|---|
| **Calidad del spec** | Improvisado; suposiciones nunca validadas → se ejecuta lo incorrecto a fondo | Spec versionado + grill adversarial ×3 (visión de sistema · realidad humana · profundidad técnica) detecta suposiciones falsas con evidencia real antes de comenzar cualquier trabajo |
| **Coste y esfuerzo** | Capacidad cara para todo, incluidas las tareas triviales | Capacidad adecuada por unidad: tier rápido para lo mecánico, tier de ejecución para planes cerrados, razonamiento profundo solo para arquitectura, grill y decisiones críticas |
| **Detección de defectos** | Verify solo al final → defectos descubiertos tarde, caros de corregir | Verify por unidad contra una definición de done preestablecida → defectos detectados temprano, baratos de corregir |
| **Trabajo en paralelo** | Workers paralelos se sobreescriben entre sí; sin reglas de propiedad; falsos "todo listo" de verificaciones parciales | Grafo de propiedad + asignación de unidades de trabajo disjuntas calculadas en el plan → colisiones prevenidas antes de ejecutar |
| **Resiliencia de sesión** | Trabajo perdido cuando un límite de cuota, un corte de sesión o una interrupción ocurren a mitad de la tarea | Checkpoints por fase + cápsula de resume por workstream: el trabajo sobrevive cualquier interrupción |
| **Trabajo repetitivo** | Quemando capacidad cara de IA en tareas mecánicas (sweeps, renombrados, búsquedas, conteos) | Herramientas y scripts para trabajo determinista; IA reservada para diseño, grill y decisiones |
| **Cuello de botella en revisión** | Revisar cada entregable en serie → cuello de botella; el revisor bloquea cada siguiente paso | Revisión asíncrona por lotes: acumula entregables de varias unidades, revisa muchos de una vez |

**La diferencia medible:** menos recursos desperdiciados en trabajo mecánico, menos defectos por suposiciones no verificadas, paralelismo real sin colisiones, trabajo siempre recuperable.

---

## El bucle de un vistazo

```mermaid
flowchart TD
    A([Trabajo sustancial identificado]) --> B[1. Alinear intención\nprimero la pregunta de valor\nuna ronda enfocada con el responsable]
    B --> C[2. Spec versionado\nartefacto escrito\npersona e IA de acuerdo]
    C --> D{3. Grill adversarial\n3 lentes hostiles\ntier de razonamiento profundo}
    D --> D1[Lente 1: Visión de sistema\nreglas · restricciones\nprecedentes verificados contra la realidad]
    D --> D2[Lente 2: Realidad humana\ncasos del día a día\nlo que rompe en la práctica]
    D --> D3[Lente 3: Profundidad técnica\nedge cases · concurrencia\nlo que falla bajo presión]
    D1 & D2 & D3 --> E{¿Hallazgos resueltos?}
    E -- No --> F[Responder y refinar\nRe-spec → Re-grill en costuras nuevas]
    F --> E
    E -- Sí --> G[4. Plan global\ntodas las unidades · sin huecos\ndependencias + propiedad mapeadas]
    G --> H{Grill del plan\ntier de razonamiento profundo}
    H -- Problemas --> G
    H -- Cerrado --> I[5. Ejecutar de forma óptima\nparalelizar unidades disjuntas\nautomatizar tareas repetitivas\ncapacidad adecuada por unidad · checkpoints]
    I --> J{Verify por unidad\nvs. definición de done}
    J -- No listo --> I
    J -- Todo listo --> K[6. Verify completo\ncontra definición de done preestablecida\nevidencia · verificación independiente]
    K --> L{¿Verificado?}
    L -- No --> I
    L -- Sí --> M[7. Aprobación del responsable\ngate humano]
    M --> N([Hecho · limpieza])
```

---

## Cómo se adapta a tu dominio

El bucle central (los 7 pasos anteriores) es agnóstico de dominio. Los **packs de dominio** lo instancian con lentes de grill, definiciones de done y pasos de verificación específicos del dominio:

| Dominio | Pack |
|---------|------|
| Software — backend, APIs, datos | [references/domain-packs/software-backend.md](references/domain-packs/software-backend.md) |
| Software — frontend, UI, sistema de diseño | [references/domain-packs/software-frontend.md](references/domain-packs/software-frontend.md) |
| Software — orquestación multi-agente | [references/domain-packs/software-agents.md](references/domain-packs/software-agents.md) |
| Seguridad, modelado de amenazas | [references/domain-packs/security.md](references/domain-packs/security.md) |
| Diseño de producto, UX/UI | [references/domain-packs/design.md](references/domain-packs/design.md) |
| Brainstorming, estrategia | [references/domain-packs/brainstorming.md](references/domain-packs/brainstorming.md) |
| Marketing, campañas, go-to-market | [references/domain-packs/marketing.md](references/domain-packs/marketing.md) |
| Modelado financiero y análisis | [references/domain-packs/finance.md](references/domain-packs/finance.md) |

Para dominios sin pack: deriva tres lentes usando el patrón visión de sistema · realidad humana · profundidad técnica de [references/grill.md](references/grill.md), y define la definición de done del dominio antes de comenzar.

---

## Ejemplos

Prompts reales listos para copiar en 8 dominios, con lo que Forge produce en cada caso:

→ [examples/](examples/README.es.md)

---

## Referencias

| Referencia | Contenido |
|------------|-----------|
| [references/the-loop.md](references/the-loop.md) | Bucle universal completo de 7 pasos |
| [references/grill.md](references/grill.md) | Método de grill adversarial + gates interactivos (entrada → ×3 → gate de usuario → re-grill informado) + tabla de lentes por dominio |
| [references/planning.md](references/planning.md) | Estructura del plan global + modelo de propiedad de unidades de trabajo |
| [references/execution-modes.md](references/execution-modes.md) | Cómo paralelizar, automatizar, tierar y hacer checkpoints |
| [references/verification.md](references/verification.md) | Definición de done + reglas de evidencia + ejemplos por dominio |
| [references/model-routing.md](references/model-routing.md) | Routing de tiers de capacidad (vendor-neutral + ejemplo de mapeo) |
| [skills/](skills/README.md) | Skills grill compañeras incluidas (`grill-me`, `grill-with-docs`) — la forma interactiva del grill |

---

## Instalación

### Como skill de Claude Code (recomendado)

```bash
git clone https://github.com/davidgarciagordo/forge-methodology ~/.claude/skills/forge-methodology
```

Claude Code detecta el skill automáticamente. Invócalo con la herramienta `Skill` usando `skill: "forge-methodology"`.

### Como regla de proyecto

Copia `SKILL.md` en el directorio de reglas de tu proyecto:

```bash
cp ~/.claude/skills/forge-methodology/SKILL.md ~/.claude/rules/forge-methodology.md
```

O copia directamente desde este repo:

```bash
curl -o ~/.claude/rules/forge-methodology.md \
  https://raw.githubusercontent.com/davidgarciagordo/forge-methodology/main/SKILL.md
```

### Sin Claude Code

Lee `SKILL.md` y el pack de dominio correspondiente. La metodología funciona con cualquier asistente de IA o como proceso de equipo humano — no requiere herramientas específicas.

---

## Licencia

MIT — ver [LICENSE](./LICENSE).

---
<sub>Hecho por [David García Gordo](https://github.com/davidgarciagordo) · MIT · parte de la familia [claude-code-setup-optimizer](https://github.com/davidgarciagordo/claude-code-setup-optimizer)</sub>
