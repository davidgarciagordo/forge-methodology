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

Load the skill (`skill: "forge-methodology"`) — or just say **"forge this"** / **"pásalo por la Forja"** — and follow its loop. It asks you at exactly **two checkpoints** (after the draft grill and after the spec re-grill), both as one multi-select batch with recommendations pre-marked — nothing executes on a decision you didn't pick.

> `/forge-run <task>` is the fully-codified runner with machine-checked phase gates — it ships in the separate [`working-methods`](https://github.com/davidgarciagordo/claude-code-setup-optimizer) plugin (same catalog). This plugin alone gives you the methodology + agents + the acceptance-matrix hook.

## How it works

The loop, in codified order:

1. **Align intent + brainstorm** — value question first; a real option space (2-3 approaches), one focused round with the owner.
2. **Reference Decomposition** — name an external reference, enumerate its capabilities into `req-id`s.
3. **Draft + grill ×3** — the chosen approach as a concrete draft, attacked by 3 hostile lenses + the Completeness-vs-Reference 4th lens (grill the draft while it's cheap to change).
4. **Owner checkpoint #1** — ONE multi-select batch: every decision the grill exposed, recommendations pre-marked.
5. **Versioned spec** — draft + verdicts + your decisions become the spec; the `req-id`s become the Acceptance Matrix, the canonical Definition of Done.
6. **Re-grill ×2** — do the fixes hold + attack the new seams the fixes created.
7. **Owner checkpoint #2** — ONE multi-select batch; after it the spec is locked.
8. **Global plan + execution proposal** — all work units, no gaps, dependencies mapped, per-phase specs written; closes proposing the most effective execution (multi-agent by default: isolated worktrees, one shared context pack, model tier per unit).
9. **Execute → verify → sign-off** — `independent-verifier` audits the matrix row by row (`verified-by ≠ executor`); a hook blocks "declare done"/`gh pr create` while any in-scope row is untraced. **GREEN ≠ COMPLETE.**

**Domain packs** instantiate the loop for backend, frontend, multi-agent orchestration, security, design, brainstorming, marketing, and finance — see [references/domain-packs/](references/domain-packs/).

Full detail: [SKILL.md](SKILL.md), [references/the-loop.md](references/the-loop.md), [references/grill.md](references/grill.md), [references/agents-overview.md](references/agents-overview.md), [hooks/README.md](hooks/README.md).

## Advantages

- Catches wrong assumptions before they're baked into deliverables — the grill runs against real evidence, not vibes.
- Makes "done" mechanical instead of advisory: the Acceptance Matrix + independent verifier + hook mean a PR can't claim completeness it doesn't have.
- Right capability tier per unit — deep reasoning only for grill/architecture/decisions, cheaper tiers for mechanical execution.

## Alternatives

- **git clone as a skill** (older, pre-plugin method): `git clone https://github.com/davidgarciagordo/forge-methodology ~/.claude/skills/forge-methodology`.
- **As a project rule** — if you want Forge enforced as a CLAUDE.md rule rather than an invoked skill, copy `SKILL.md` into your rules directory: `cp SKILL.md ~/.claude/rules/forge-methodology.md`.

## License

MIT © David García Gordo
