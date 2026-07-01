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

```bash
/forge-run <tu tarea>
```

O carga la skill directamente (`skill: "forge-methodology"`) y sigue su loop. Te pregunta en los gates de **spec/grill** y **plan** (multi-select, recomendaciones premarcadas) — nada se ejecuta sobre una decisión que no marcaste.

## Cómo funciona

El bucle, en orden codificado:

1. **Alinear intención** — primero la pregunta de valor, una ronda enfocada con el responsable.
2. **Descomposición de la referencia** — nombra una referencia externa, enumera sus capacidades en `req-id`s.
3. **Spec versionado** — los `req-id`s se convierten en la Matriz de Aceptación, el DoD canónico.
4. **Grill adversarial ×3** — visión de sistema, realidad humana, profundidad técnica — más una 4ª lente, Completitud vs Referencia, que marca como hallazgo bloqueante cualquier capacidad de la referencia ausente del spec.
5. **Plan global** — todas las unidades de trabajo, sin huecos, dependencias y propiedad mapeadas, grillado antes de cerrarlo.
6. **Ejecutar** — paraleliza unidades disjuntas, capacidad adecuada por unidad, checkpoint por fase.
7. **Verify** — `independent-verifier` audita la matriz fila a fila (`verified-by ≠ ejecutor`); un hook bloquea "declarar hecho"/`gh pr create` mientras una fila in-scope no esté trazada. **GREEN ≠ COMPLETE.**
8. **Aprobación del responsable.**

Los **packs de dominio** instancian el bucle para backend, frontend, orquestación multi-agente, seguridad, diseño, brainstorming, marketing y finanzas — ver [references/domain-packs/](references/domain-packs/).

Detalle completo: [SKILL.md](SKILL.md), [references/the-loop.md](references/the-loop.md), [references/grill.md](references/grill.md), [agents/README.md](agents/README.md), [hooks/README.md](hooks/README.md).

## Ventajas

- Detecta suposiciones erróneas antes de que queden integradas en los entregables — el grill corre contra evidencia real, no intuición.
- Hace que "hecho" sea mecánico en vez de advisory: la Matriz de Aceptación + verificador independiente + hook impiden que un PR reclame una completitud que no tiene.
- Capacidad adecuada por unidad — razonamiento profundo solo para grill/arquitectura/decisiones, tiers más baratos para la ejecución mecánica.

## Alternativas

- **git clone como skill** (método más antiguo, previo a los plugins): `git clone https://github.com/davidgarciagordo/forge-methodology ~/.claude/skills/forge-methodology`.
- **Como regla de proyecto** — si quieres Forge como regla de CLAUDE.md en vez de skill invocada, copia `SKILL.md` a tu directorio de reglas: `cp SKILL.md ~/.claude/rules/forge-methodology.md`.

## Licencia

MIT © David García Gordo
