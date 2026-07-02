[English](README.md) | **Español**

# forge-methodology

Plugin de Claude Code. Metodología humano↔IA para trabajo sustancial: alinear intención → descomponer la referencia → spec versionado (con Matriz de Aceptación) → grill adversarial ×3 (+ 4ª lente de completitud) → plan global → ejecución optimizada → verify vs DoD → aprobación del responsable.

Sáltatela en lo trivial (one-liners, formato). Forge es para el trabajo donde equivocar el diseño sale caro.

## Instalación

Solo este plugin:

```bash
/plugin marketplace add davidgarciagordo/forge-methodology
/plugin install forge-methodology
```

O toda la suite (este + design-review, token-economy, working-methods, automations) desde [un único catálogo](https://github.com/davidgarciagordo/claude-plugins):

```bash
/plugin marketplace add davidgarciagordo/claude-plugins
/plugin install forge-methodology@davidgarciagordo-plugins
```

## Cómo se usa

Carga la skill (`skill: "forge-methodology"`) — o di **"pásalo por la Forja"** / **"forja esto"** — y sigue su loop. Te pregunta en exactamente **dos checkpoints** (tras el grill del borrador y tras el re-grill del spec), ambos como un solo lote multi-select con recomendaciones premarcadas — nada se ejecuta sobre una decisión que no marcaste.

> `/forge-run <tarea>` es el runner totalmente codificado con gates de fase machine-checked — viene en el plugin aparte [`working-methods`](https://github.com/davidgarciagordo/claude-code-setup-optimizer) (mismo catálogo). Este plugin solo te da la metodología + agentes + el hook de la Matriz de Aceptación.

## Cómo funciona

El bucle, en orden codificado:

1. **Alinear intención + brainstorm** — primero la pregunta de valor; espacio de opciones real (2-3 enfoques), una ronda enfocada con el responsable.
2. **Descomposición de la referencia** — nombra una referencia externa, enumera sus capacidades en `req-id`s.
3. **Borrador + grill ×3** — el enfoque elegido como borrador concreto, atacado por 3 lentes hostiles + la 4ª lente de Completitud vs Referencia (grillar el borrador cuando cambiar es barato).
4. **Checkpoint del responsable #1** — UN lote multi-select: cada decisión que el grill destapó, recomendaciones premarcadas.
5. **Spec versionado** — borrador + veredictos + tus decisiones se convierten en el spec; los `req-id`s en la Matriz de Aceptación, el DoD canónico.
6. **Re-grill ×2** — ¿aguantan los fixes? + atacar las costuras nuevas que los fixes crearon.
7. **Checkpoint del responsable #2** — UN lote multi-select; tras él el spec queda cerrado.
8. **Plan global + propuesta de ejecución** — todas las unidades, sin huecos, dependencias mapeadas, specs por fase escritos; cierra proponiendo la ejecución más efectiva (multiagente por defecto: worktrees aislados, un context-pack compartido, modelo por unidad).
9. **Ejecutar → verify → aprobación** — `independent-verifier` audita la matriz fila a fila (`verified-by ≠ ejecutor`); un hook bloquea "declarar hecho"/`gh pr create` mientras una fila in-scope no esté trazada. **GREEN ≠ COMPLETE.**

Los **packs de dominio** instancian el bucle para backend, frontend, orquestación multi-agente, seguridad, diseño, brainstorming, marketing y finanzas — ver [references/domain-packs/](references/domain-packs/).

Detalle completo: [SKILL.md](SKILL.md), [references/the-loop.md](references/the-loop.md), [references/grill.md](references/grill.md), [references/agents-overview.md](references/agents-overview.md), [hooks/README.md](hooks/README.md).

## Ventajas

- Detecta suposiciones erróneas antes de que queden integradas en los entregables — el grill corre contra evidencia real, no intuición.
- Hace que "hecho" sea mecánico en vez de advisory: la Matriz de Aceptación + verificador independiente + hook impiden que un PR reclame una completitud que no tiene.
- Capacidad adecuada por unidad — razonamiento profundo solo para grill/arquitectura/decisiones, tiers más baratos para la ejecución mecánica.

## Alternativas

- **git clone como skill** (método más antiguo, previo a los plugins): `git clone https://github.com/davidgarciagordo/forge-methodology ~/.claude/skills/forge-methodology`.
- **Como regla de proyecto** — si quieres Forge como regla de CLAUDE.md en vez de skill invocada, copia `SKILL.md` a tu directorio de reglas: `cp SKILL.md ~/.claude/rules/forge-methodology.md`.

## Licencia

MIT © David García Gordo
