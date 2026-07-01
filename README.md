**English** | [Español](README.es.md)

# forge-methodology

Claude Code plugin. Human↔AI methodology for substantial work: align intent → decompose the reference → versioned spec (with an Acceptance Matrix) → adversarial grill ×3 (+ a 4th completeness lens) → global plan → optimised execution → verify vs DoD → owner sign-off.

Skip it for trivials (one-liners, formatting). Forge is for work where getting the design wrong is expensive.

## Install

Just this plugin:

```bash
/plugin marketplace add davidgarciagordo/forge-methodology
/plugin install forge-methodology
```

Or the whole suite (this + design-review, token-economy, working-methods, automations) from [one catalog](https://github.com/davidgarciagordo/claude-plugins):

```bash
/plugin marketplace add davidgarciagordo/claude-plugins
/plugin install forge-methodology@davidgarciagordo-plugins
```

## How to use

```bash
/forge-run <your task>
```

Or load the skill directly (`skill: "forge-methodology"`) and follow its loop. It asks you at the **spec/grill** and **plan** gates (multi-select, recommendations pre-marked) — nothing executes on a decision you didn't pick.

## How it works

The loop, in codified order:

1. **Align intent** — value question first, one focused round with the owner.
2. **Reference Decomposition** — name an external reference, enumerate its capabilities into `req-id`s.
3. **Versioned spec** — the `req-id`s become the Acceptance Matrix, the canonical Definition of Done.
4. **Adversarial grill ×3** — system view, human reality, technical depth — plus a 4th lens, Completeness vs Reference, that flags any reference capability missing from the spec as a blocking finding.
5. **Global plan** — all work units, no gaps, dependencies and ownership mapped, grilled before locking.
6. **Execute** — parallelise disjoint units, right capability tier per unit, checkpoint per phase.
7. **Verify** — `independent-verifier` audits the matrix row by row (`verified-by ≠ executor`); a hook blocks "declare done"/`gh pr create` while any in-scope row is untraced. **GREEN ≠ COMPLETE.**
8. **Owner sign-off.**

**Domain packs** instantiate the loop for backend, frontend, multi-agent orchestration, security, design, brainstorming, marketing, and finance — see [references/domain-packs/](references/domain-packs/).

Full detail: [SKILL.md](SKILL.md), [references/the-loop.md](references/the-loop.md), [references/grill.md](references/grill.md), [agents/README.md](agents/README.md), [hooks/README.md](hooks/README.md).

## Advantages

- Catches wrong assumptions before they're baked into deliverables — the grill runs against real evidence, not vibes.
- Makes "done" mechanical instead of advisory: the Acceptance Matrix + independent verifier + hook mean a PR can't claim completeness it doesn't have.
- Right capability tier per unit — deep reasoning only for grill/architecture/decisions, cheaper tiers for mechanical execution.

## Alternatives

- **git clone as a skill** (older, pre-plugin method): `git clone https://github.com/davidgarciagordo/forge-methodology ~/.claude/skills/forge-methodology`.
- **As a project rule** — if you want Forge enforced as a CLAUDE.md rule rather than an invoked skill, copy `SKILL.md` into your rules directory: `cp SKILL.md ~/.claude/rules/forge-methodology.md`.

## License

MIT © David García Gordo
