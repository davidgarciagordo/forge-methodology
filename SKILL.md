---
name: forge-methodology
description: "Domain-agnostic human↔AI methodology for substantial work — produces: aligned intent → versioned spec → adversarially grilled spec → global plan → optimised execution → verified done → owner sign-off. Use when the user invokes `/forge-run`, says 'run it through the Forge' / 'forge this' / 'pásalo por la Forja' / 'forja', OR starts substantial work too important to improvise: a new feature, an architecture/security decision, a marketing campaign, a financial/research analysis — any domain where getting the design wrong is expensive. Skip for trivials (one-liners, formatting)."
---

# Forge — Methodology for Substantial Work with AI

> **"Run it through the Forge"** = apply this pipeline. Use for any substantial work where getting the design wrong is expensive: new features, architectural decisions, campaigns, analyses, assessments, research. Go direct for trivials (one-liners, formatting, minor tweaks).

Forge is not a process for everything. It is for the work where improvising the design produces thorough execution of the wrong thing.

---

## Adapt the Pipeline to What Already Exists

**Intelligence = adapting the loop to what already exists, not recreating it from scratch.**

Before starting any phase, check whether its artifact is already done (spec exists, plan exists, prior art exists). If it exists: **review it, grill it, refine it — do NOT recreate from scratch.** Skip or compress phases whose output is already done and verified. Reuse, do not duplicate work. Enter the loop at the right point.

> **The non-skippable floor — Adapt reorders, it never deletes.** No matter how much prior art exists, two
> things are never compressed away: **(1) the Reference-matrix** — the enumerated reference and its Acceptance
> Matrix in the spec — and **(2) the independent verify against that matrix** (the `independent-verifier` /
> `completeness-critic` pass + the GREEN ≠ COMPLETE gate). "We're adapting an existing spec / the tests pass"
> is not a reason to skip either. Adapt may merge or fast-path other steps; it may never delete these two.

---

## The Loop

Full detail in [references/the-loop.md](references/the-loop.md). The owner decides at exactly
**two checkpoints** (steps 4 and 7), both as ONE multi-select batch with recommendations
pre-marked — everything else runs without interrupting them.

### 1. Align Intent + Brainstorm
Lead with the **value question first**: what problem does this actually solve and for whom? Run a
real brainstorm — surface the option space (2-3 genuinely different approaches with trade-offs),
not just the first idea restated. One focused round with the owner: explicit decisions on scope,
constraints, trade-offs, non-goals. Hard gate: **nothing gets executed until intent is aligned.**

### 2. Reference Decomposition
**Name the external reference the work is measured against, and enumerate its in-scope capabilities as a flat list** (each with a stable `req-id`). This is the cure for "Done against ourselves, not against the goal." The reference is a *named, inspectable thing* (competitor, spec, regulation, prior system) — not "best practices." The enumerated list **becomes the Acceptance Matrix** in the spec and threads forward to plan and verify. Genuinely novel work declares **greenfield** explicitly and enumerates from first principles. Run with the `reference-decomposer` agent; confirm nothing is missing with `completeness-critic`.

### 3. Draft + Grill ×3
Write the **draft** — the chosen approach worked into a concrete design/plan sketch (not yet the
formal spec). Then three independent hostile lenses attack the DRAFT — **plus the standing fourth
lens, Completeness vs Reference, whenever there is an external reference.** The first three hunt
what *breaks*; the fourth hunts what is *missing*: **a reference requirement not covered is a
blocking finding. An unverified assumption is a finding.** Deep-reasoning tier, read-only lenses.
Grilling the draft (cheap to change) before the spec (expensive to change) is the point.

See [references/grill.md](references/grill.md) for the full method and the lens table by domain.

### 4. Owner Checkpoint #1 — multi-select with recommendations
Surface the grill's emergent decisions to the owner as **ONE `AskUserQuestion` batch
(multi-select)**: each item = a real decision the grill exposed, with **your recommended answer
pre-marked** and the alternatives (+ the owner can add or dispute). Never a stream of one-off
questions; never a decision buried in prose. The orchestrator runs this gate — never a grill
subagent (subagents cannot talk to the owner).

### 5. Versioned Spec
Integrate the draft + grill verdicts + owner decisions into the formal spec — a written artifact
both human and AI agree on, specific enough that a third party could verify the outcome against
it. Versioned and kept alongside the work. **The Definition of Done lives canonically here, as the
Acceptance Matrix** (`req-id | source | in-scope? | built? | evidence | verified-by ≠ executor`)
plus an explicit **Non-goals** section. Use [templates/spec-and-dod.md](templates/spec-and-dod.md). DoD is fixed in the spec — never deferred to the plan or the final sign-off.

### 6. Re-Grill ×2 (the spec)
Two focused passes over the SPEC: (a) **do the fixes hold** — verify every checkpoint-#1 decision
landed and survives attack; (b) **the new seams** — the fixes themselves create new edges; attack
those, plus re-verify assumptions against the real repo. Not a third full grill — the draft
already had one; this is regression + novelty.

### 7. Owner Checkpoint #2 — multi-select with recommendations
Same mechanism as #4: ONE multi-select batch with the re-grill's outcomes and any remaining
owner-only calls (cut lines, phasing v1/v1.1/v2, budget), recommendations pre-marked. After this
gate the spec is **locked**.

### 8. Global Plan + Execution Proposal
All work units, all phases, no gaps — **before any execution begins.** Dependency graph computed;
parallelizable vs serial derived from it; per-phase specs/plans written and versioned. Close with
an explicit **execution proposal**: the most agile, clear and effective way to run the plan —
**multi-agent by default when units are disjoint** (isolated worktrees per writer, ONE shared
context pack with file:line so no agent re-discovers, read-only+terse diagnosis lenses, the right
model tier per unit, deterministic tools before model effort). Present the proposal in one line
per phase; the owner already decided everything else at the checkpoints.

See [references/planning.md](references/planning.md) and [references/execution-modes.md](references/execution-modes.md).

### 9. Execute → Verify → Sign-off
Execute per the proposal: parallelize disjoint units in isolated workspaces, select from the
plan's ready set — never improvise; checkpoint per phase. Then verify against the DoD: **GREEN ≠
COMPLETE** — GREEN = existing tests pass; COMPLETE = every in-scope reference requirement traced
to evidence and independently verified. **Verify audits the matrix, not the diff** — every
in-scope row `built = yes` + real evidence + `verified-by ≠ executor` (run `independent-verifier`
+ `completeness-critic`; the `hooks/check-acceptance-matrix.sh` hook **blocks** declare-done/PR
while any in-scope row is untraced). Finally the human owner reviews the verified output and signs
off — evidence, not assertions; outstanding decisions and non-goals surfaced; the owner can cycle
back to any earlier step.

See [references/verification.md](references/verification.md) for the method and domain examples.

---

## How to Detect the Domain and Load the Right Pack

When starting a Forge session, identify the primary domain of the work and load the corresponding domain pack. Domain packs instantiate the universal loop with:
- The three grill lenses for that domain
- The definition of done for that domain
- Domain-specific verification steps

| Domain | Pack |
|--------|------|
| Software — backend, APIs, data | [references/domain-packs/software-backend.md](references/domain-packs/software-backend.md) |
| Software — frontend, UI, design system | [references/domain-packs/software-frontend.md](references/domain-packs/software-frontend.md) |
| Software — multi-agent, multi-worker orchestration | [references/domain-packs/software-agents.md](references/domain-packs/software-agents.md) |
| Security assessment, threat modeling | [references/domain-packs/security.md](references/domain-packs/security.md) |
| Product design, UX/UI, design systems | [references/domain-packs/design.md](references/domain-packs/design.md) |
| Brainstorming, strategy, decision-making | [references/domain-packs/brainstorming.md](references/domain-packs/brainstorming.md) |
| Marketing, campaigns, go-to-market | [references/domain-packs/marketing.md](references/domain-packs/marketing.md) |
| Financial modeling, analysis, reporting | [references/domain-packs/finance.md](references/domain-packs/finance.md) |

For domains not covered by a pack, derive the three lenses using the pattern in [references/grill.md](references/grill.md) (system view · human reality · technical depth) and define the domain's definition of done before starting.

---

## Cross-Cutting Principles

### Model Per Task (most important cost control)

Always match the capability tier to the work. Full routing guide: [references/model-routing.md](references/model-routing.md).

| Tier | Use for |
|------|---------|
| **Fast tier** | Trivial / mechanical: one-liners, formatting, stubs, status updates, routine coordination |
| **Execution tier** | Executing a closed plan, refactors, migrations, high-volume work |
| **Deep-reasoning tier** | Architecture, adversarial grill, arbitration, critical review, resolving ambiguity |

Do not use the deep-reasoning tier where the execution tier performs equally well. Applies to every agent in a workflow, including the orchestrator.

### Automate Before Spending Effort

Repetitive, mechanical, or high-volume tasks → automate with a tool, script, or program before spending AI capability or human effort. Reserve AI for design, grill, and decisions. Two concrete rules:

- **Deterministic external tooling = run the tool, not a model.** Linters, formatters, type-checkers, codemods (eslint · prettier · rector · ecs · phpstan · ruff · gofmt · tsc · biome…) are run as **tools**, preferring their **`--fix`/autofix** so they self-resolve. A model is spent only on the **residual** the tool cannot auto-fix (interpret + patch), at the **cheapest tier** that works. **Never put a reasoning model — least of all the deep-reasoning tier — in front of a tool that has `--fix`.** (A common anti-pattern: running the top model to "do" rector/ecs/phpstan, which only have to be *executed*.)
- **Mechanical bulk → a temp script, not hand-editing.** For sweeps, renames, counts, and repetitive transforms, generate a throwaway bash/python script and run it deterministically (cheapest model, or none) instead of editing N files through the model one by one.

### Token Economy in Multi-Agent Work (discover once, judge many)

When a step fans out to multiple agents (parallel grill lenses, per-carril execution, research sweep), the default failure is **every agent re-discovers the same context and writes essays** — measured on a real run at ~80% redundant work and ~5× the necessary tokens. Five rules:

1. **Discover once, reuse.** Phase 1 builds a shared **context pack** (file:line map + the already-known findings); downstream agents **read the pack**, they do not re-scan the source or re-derive what's known. Chain each phase's result forward as the next phase's input.
2. **Terse agent output.** A sub-agent's last message is data for the orchestrator, not a human report. Require: line 1 `OK`/`KO` + ≤8-word why, then findings one line each (`tag · file:line · problem → fix`). No preamble, no restating the brief, no summary tables, no essays. This alone cuts output tokens hard.
3. **Analyze read-only; mutate in ONE pass.** Grill / review / diagnosis agents get **no write tools** — they return findings. All edits happen in a single apply pass *after* the decision gate. Parallel agents with write access edit the same files uncoordinated and bypass the user gate.
4. **Pluggable memory (optional accelerator, never required).** If a persistent memory tool exists (any `search`/`write`-style), the **orchestrator** (not each agent — avoids write races) searches before a phase to skip rediscovery and writes confirmed results + reusable research after. With none, fall back to file artifacts — never block.
5. **Cap exploration, cache by domain.** Bound web/browser fan-out (N sources, 1 capture each); cache reusable research keyed by domain so re-runs and loops don't re-pay for it.

The win compounds across iterations: the 2nd+ pass over the same target reuses the context pack and costs a fraction of the first.

### Specs and Plans are Versioned Artifacts

They live alongside the work, committed. Work survives the session (checkpoint per phase/milestone).

### Disagree With Data

Disagreeing with the plan — with evidence and reasoning — is part of the role. Raise it early, with specifics.

---

## The Mechanical Completeness Spine

Forge's references are *reasoning you load*. The spine is the set of **executable units** that make
completeness mechanical instead of advisory — they cure "the advisory gets skipped / Done against ourselves,
not against the goal." One artifact (the **enumerated reference → Acceptance Matrix**) threads research → spec
→ plan → verify, enforced at every step:

| Unit | Kind | Enforces |
|------|------|----------|
| [templates/spec-and-dod.md](templates/spec-and-dod.md) | template | DoD = Acceptance Matrix, canonical in the spec; Reference Standard enumerated or greenfield declared |
| [`reference-decomposer`](agents/reference-decomposer.md) | agent | reference → enumerated `req-id` list → seeds the matrix |
| [`completeness-critic`](agents/completeness-critic.md) | agent | 4th grill lens: a reference capability absent from spec/plan = **blocking** (early **and** at verify) |
| [`independent-verifier`](agents/independent-verifier.md) | agent | row-by-row matrix audit; evidence per row; `verified-by ≠ executor` |
| [`visual-fidelity-checker`](agents/visual-fidelity-checker.md) | agent | per-UI-surface side-by-side vs. the reference's screen (external fidelity ≠ theme parity) |
| [hooks/check-acceptance-matrix.sh](hooks/check-acceptance-matrix.sh) | hook | **blocks** "declare done"/`gh pr create` while any in-scope row lacks built + evidence + independent verify |
| `Satisfies-reqs` in the plan | field | every in-scope `req-id` is owned by a work unit |

Full map: [references/agents-overview.md](references/agents-overview.md) · install the hook: [hooks/README.md](hooks/README.md).

## Templates

- [templates/spec-and-dod.md](templates/spec-and-dod.md) — spec with Reference Standard + Acceptance Matrix (the canonical DoD)
- [templates/work-unit-plan.md](templates/work-unit-plan.md) — declare a work unit in the plan (with `Satisfies-reqs`)
- [templates/state-capsule.md](templates/state-capsule.md) — resume capsule per workstream
- [templates/phase-gate-checklist.md](templates/phase-gate-checklist.md) — gate a phase before advancing

---

## Optional Accelerators (Claude Code)

Forge is self-contained and works with any AI assistant or human team. In **Claude Code**, several skills automate parts of the pipeline:

- `superpowers:brainstorming` — structured facilitation for Step 1
- `superpowers:writing-plans` — guided planning for Step 4
- `forge-methodology:grill-me` — adversarial review harness for the grill steps (qualified name — a popular standalone `grill-me` skill also exists)

These are accelerators, not requirements. The methodology stands on its own without them.
