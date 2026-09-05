**English** | [Español](README.es.md)

# 🔥 forge-methodology

AI-assisted work fails in two repeatable ways, and both look like success until someone checks. **"Done against ourselves, not against the goal"**: the work gets measured against the executor's own checklist instead of the thing it was supposed to match — a "parity with X" project ships with half of X because nobody ever enumerated what X does. And **"self-verified-green"**: the same agent that built the thing declares it verified, and green tests over *what exists* get mistaken for a complete result. Forge is a 9-step human↔AI methodology (a Claude Code plugin) that turns both failures from advisories into **code**: the external reference is enumerated into an **Acceptance Matrix** — one `req-id` per capability — and a hook **blocks `gh pr create`** while any in-scope row lacks real evidence or an independent verifier. Completeness stops being a promise and becomes an exit code.

## 📦 Install

Just this plugin:

```bash
/plugin marketplace add davidgarciagordo/forge-methodology
/plugin install forge-methodology
```

Or the whole suite (this + design-review, token-economy, working-methods, automations, swarm) from [one catalog](https://github.com/davidgarciagordo/claude-plugins):

```bash
/plugin marketplace add davidgarciagordo/claude-plugins
/plugin install forge-methodology@davidgarciagordo-plugins
```

## 🚀 Quick start

1. Install (above), then say **"forge this: add idempotent payment webhooks, parity with Stripe's webhook spec"** — the loop runs, asking you at exactly **two checkpoints** (multi-select batches, recommendations pre-marked).
2. Step 2 enumerates the reference into `req-id`s; the spec's **Acceptance Matrix** becomes the Definition of Done:

   | req-id | source (ref §/screen) | in-scope? | built? | evidence (test/screenshot/link) | verified-by (≠ executor) |
   |--------|----------------------|-----------|--------|---------------------------------|--------------------------|
   | R1 | Stripe docs §retries | yes | yes | `tests/webhooks.retry.test.ts` | independent-verifier |
   | R2 | Stripe docs §signatures | yes | yes | — | — |
   | R3 | Stripe docs §event-types | yes | no | — | — |
   | R4 | Stripe docs §thin-payloads | no | — | (out of scope — see Non-goals) | — |

3. Declare done too early — the hook intercepts `gh pr create` and blocks (exit 2), with this real output:

   ```
   FORGE BLOCK — Acceptance Matrix is not COMPLETE. Cannot declare done / open PR.
   GREEN (tests pass on what exists) ≠ COMPLETE (every in-scope requirement traced to evidence + independently verified).
   Incomplete in-scope rows:
     [.forge/spec.md] R2 -> no-evidence no-verified-by
     [.forge/spec.md] R3 -> built≠yes no-evidence no-verified-by
   ```

4. Build R3, then run `/forge-verify-matrix` (or the `independent-verifier` agent) to fill evidence + an independent `verified-by` for R2 and R3.
5. `gh pr create` again → `forge: Acceptance Matrix COMPLETE — all in-scope rows built + evidenced + independently verified.`

> **What the hook does and does not guarantee.** It is a `PreToolUse` guardrail on the agent's own `gh pr create` (plus opt-in `[forge-done]` / `FORGE_DONE=1` markers). It stops the *agent* from declaring done early; it is **not** server-side branch protection — a human pushing and merging from the web UI bypasses it. For a server-side gate, run the same script in CI ([hooks/README.md](hooks/README.md) shows the invocation). **It is also fail-open by default**: if it finds no Acceptance Matrix at all, it prints a notice and does **not** block — the repo may simply not be using Forge for that PR. Set `FORGE_REQUIRE_MATRIX=1` if you want a missing matrix to be a blocking condition too.

## 🧩 What's in the box

| Component | Type | What it does | Invocation |
|---|---|---|---|
| [`forge-methodology`](SKILL.md) | skill | The 9-step loop: intent → reference → grilled spec → plan → verified done | say **"forge this"** / **"pásalo por la Forja"**, or `skill: "forge-methodology"` |
| [`grill-me`](skills/grill-me/SKILL.md) | skill | Standalone adversarial interview on any plan — 3 passes, one decision batch, informed pass | say **"grill me"**, or `skill: "grill-me"` |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | skill | Same grill, plus challenges the plan against `CONTEXT.md`/ADRs and updates docs inline | `skill: "grill-with-docs"` |
| [`reference-decomposer`](agents/reference-decomposer.md) | agent (execution tier) | Turns a named reference into the enumerated `req-id` list that seeds the matrix | subagent — loop step 2 |
| [`completeness-critic`](agents/completeness-critic.md) | agent (deep tier) | 4th grill lens: hunts what is **missing** vs the reference (absence = blocking) | subagent — steps 3 and 9 |
| [`independent-verifier`](agents/independent-verifier.md) | agent (deep tier) | Row-by-row matrix audit: real evidence per row, `verified-by ≠ executor` | subagent — step 9 |
| [`visual-fidelity-checker`](agents/visual-fidelity-checker.md) | agent (execution tier) | Side-by-side of each built UI surface vs the reference's equivalent screen | subagent — UI rows |
| [`/forge-verify-matrix`](commands/forge-verify-matrix.md) | command | Manual run of the completeness gate + the two verify agents | `/forge-verify-matrix` |
| [`check-acceptance-matrix.sh`](hooks/check-acceptance-matrix.sh) | hook (`PreToolUse` on Bash) | Blocks `gh pr create` / `[forge-done]` while any in-scope row is untraced | automatic once installed |
| [templates/](templates/) | 4 templates | [spec-and-dod](templates/spec-and-dod.md) (the matrix), [work-unit-plan](templates/work-unit-plan.md) (`Satisfies-reqs`), [state-capsule](templates/state-capsule.md), [phase-gate-checklist](templates/phase-gate-checklist.md) | copy into your repo |
| [references/](references/) | 7 docs + 8 domain packs | [the-loop](references/the-loop.md), [grill](references/grill.md), [planning](references/planning.md), [execution-modes](references/execution-modes.md), [model-routing](references/model-routing.md), [verification](references/verification.md), [agents-overview](references/agents-overview.md) | loaded by the skill |
| [examples/](examples/README.md) | examples | 8 copy-paste end-to-end prompts across domains | copy-paste |

## ⚙️ How it works — the 9-step loop

1. **Align intent + brainstorm** — value question first; a real option space (2-3 approaches), one focused round with the owner.
2. **Reference Decomposition** — name an external reference, enumerate its capabilities into `req-id`s.
3. **Draft + grill ×3** — the chosen approach as a concrete draft, attacked by 3 hostile lenses + the Completeness-vs-Reference 4th lens (grill the draft while it's cheap to change).
4. **Owner checkpoint #1** — ONE multi-select batch: every decision the grill exposed, recommendations pre-marked.
5. **Versioned spec** — draft + verdicts + your decisions become the spec; the `req-id`s become the Acceptance Matrix, the canonical Definition of Done.
6. **Re-grill ×2** — do the fixes hold + attack the new seams the fixes created.
7. **Owner checkpoint #2** — ONE multi-select batch; after it the spec is locked.
8. **Global plan + execution proposal** — all work units, no gaps, dependencies mapped, per-phase specs written; closes proposing the most effective execution (multi-agent by default: isolated worktrees, one shared context pack, model tier per unit).
9. **Execute → verify → sign-off** — `independent-verifier` audits the matrix row by row (`verified-by ≠ executor`); the hook blocks "declare done"/`gh pr create` while any in-scope row is untraced. **GREEN ≠ COMPLETE.**

**Domain packs** instantiate the loop with domain-specific lenses and done-criteria — 8 packs: [software-backend](references/domain-packs/software-backend.md) · [software-frontend](references/domain-packs/software-frontend.md) · [software-agents](references/domain-packs/software-agents.md) · [security](references/domain-packs/security.md) · [design](references/domain-packs/design.md) · [brainstorming](references/domain-packs/brainstorming.md) · [marketing](references/domain-packs/marketing.md) · [finance](references/domain-packs/finance.md).

**See it applied → [examples/](examples/README.md)**: 8 end-to-end prompts (backend feature, UI redesign, security audit, product decision, marketing campaign, financial model, zero-downtime migration, vendor evaluation), each with the lenses that fire and what "done" looks like.

Full detail: [SKILL.md](SKILL.md), [references/the-loop.md](references/the-loop.md), [references/grill.md](references/grill.md), [references/agents-overview.md](references/agents-overview.md), [hooks/README.md](hooks/README.md).

## 📖 Glossary

- **Grill** — an adversarial review pass: independent hostile lenses attack a draft or spec to break it while changing it is still cheap.
- **Lens** — one grill perspective with its own failure hypothesis (e.g. platform architect · real operator · domain engineer); the standing 4th lens hunts what is *missing*, not what breaks.
- **Acceptance Matrix / req-id** — the enumerated reference as a table, one stable `req-id` per capability; the single artifact threaded research → spec → plan → verify, and the table the hook parses.
- **DoD (Definition of Done)** — every in-scope matrix row `built = yes` + checkable evidence + independent `verified-by`; fixed canonically in the spec, never deferred to the plan or the sign-off.
- **GREEN ≠ COMPLETE** — GREEN = the tests that exist pass over what was built; COMPLETE = every in-scope reference requirement traced to evidence and independently verified. Only COMPLETE is done.
- **State capsule** — the per-workstream resume artifact ([template](templates/state-capsule.md)) so work survives sessions, quotas, and interruptions.

## 🚫 When NOT to use it

**The trigger is design vs execution, not file count.** Go direct — no Forge — when the work is *executing something already decided*: a bug fix, a mechanical sweep or migration, applying a written plan or review findings (even across many files), or a single reversible edit. Use Forge when the work needs a design decision that is expensive to get wrong: parity with a named reference, a new feature/product/integration, an architecture or security decision, a behavior contract others depend on.

Honest cost: a full run spends **4+ deep-reasoning-tier passes before any execution** (grill ×3 + completeness lens, re-grill ×2, plan grill, independent verify). Below a certain work size the methodology costs more than the mistake it prevents — that's what the trigger above is for. Count decisions, not files.

## ❓ `/forge-run`?

`/forge-run <task>` — the fully-codified runner with machine-checked phase gates — is **not in this plugin**; it ships in the separate [`working-methods`](https://github.com/davidgarciagordo/claude-code-setup-optimizer) plugin (same catalog). Standalone, this plugin gives you the methodology skill (triggered by "forge this"), the two grill skills, the 4 agents, the `/forge-verify-matrix` command, and the acceptance-matrix hook.

## 🔀 Alternatives

- **git clone as a skill** (older, pre-plugin method): `git clone https://github.com/davidgarciagordo/forge-methodology ~/.claude/skills/forge-methodology`.
- **As a project rule** — if you want Forge enforced as a CLAUDE.md rule rather than an invoked skill, copy `SKILL.md` into your rules directory: `cp SKILL.md ~/.claude/rules/forge-methodology.md`.

## ⚖️ License

MIT © David García Gordo
