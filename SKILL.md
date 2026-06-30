---
name: forge-methodology
description: "Domain-agnostic human↔AI methodology that, given any substantial task, produces: aligned intent → versioned spec → adversarially grilled spec → global plan → optimised execution → verified done → owner sign-off. Applies to software, security, design, marketing, finance, research, operations, or any domain where getting the design wrong is expensive. Skip for trivials (one-liners, formatting)."
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

## The Loop (7 Steps)

Full detail in [references/the-loop.md](references/the-loop.md).

### 1. Align Intent
Lead with the **value question first**: what problem does this actually solve and for whom? One focused round with the owner. Explicit decisions on scope, constraints, trade-offs, non-goals. Hard gate: **nothing gets executed until intent is aligned.**

### 1.5. Reference Decomposition
**Name the external reference the work is measured against, and enumerate its in-scope capabilities as a flat list** (each with a stable `req-id`). This is the cure for "Done against ourselves, not against the goal." The reference is a *named, inspectable thing* (competitor, spec, regulation, prior system) — not "best practices." The enumerated list **becomes the Acceptance Matrix** in the spec and threads forward to plan and verify. Genuinely novel work declares **greenfield** explicitly and enumerates from first principles. Run with the `reference-decomposer` agent; confirm nothing is missing with `completeness-critic`.

### 2. Write a Versioned Spec
A written artifact — both human and AI agree on it. Specific enough that a third party could verify whether the outcome meets it. Versioned and kept alongside the work. **The Definition of Done lives canonically here, as the Acceptance Matrix** (`req-id | source | in-scope? | built? | evidence | verified-by ≠ executor`) plus an explicit **Non-goals** section. Use [templates/spec-and-dod.md](templates/spec-and-dod.md). DoD is fixed in the spec — never deferred to the plan or the final sign-off.

### 3. Adversarial Grill
Three independent hostile lenses review the spec — **plus a standing fourth lens, Completeness vs Reference, whenever there is an external reference.** The first three hunt what *breaks*; the fourth hunts what is *missing*: **a reference requirement not covered is a finding** (blocking for any in-scope capability absent from the spec/plan). **An unverified assumption is a finding.** Deep-reasoning tier. After: respond → re-spec → re-grill on new seams → repeat until green.

When a human owns the call, the grill runs **interactively**: an **entry gate** of grounded clarifiers (one batch), the three automatic passes, a **user gate** that surfaces the emergent doubts — each with your recommended answer + alternatives, for the owner to accept / change / add to / dispute — then an informed re-grill. The gate is run by the orchestrator, never by a grill subagent.

See [references/grill.md](references/grill.md) for the full method, the interactive gates, and the lens table by domain.

### 4. Global Plan
All work units, all phases, no gaps — **before any execution begins.** Dependency graph computed. Parallelizable vs. serial derived from the graph. Grill the plan before locking it.

See [references/planning.md](references/planning.md) for the plan structure and work-unit template.

### 5. Execute Optimally
Parallelize disjoint work units, each in its **own isolated workspace** (a branch + worktree, or a per-unit sandbox) so parallel writers never collide on disk. Share **one context pack** (key locations with file:line, decisions, vocabulary) so no agent re-discovers what another already found. Select the next unit from the plan's ready set — never improvise. Automate repetitive/mechanical tasks with tools before spending AI capability. Right capability tier per work unit. Checkpoint per phase.

See [references/execution-modes.md](references/execution-modes.md) for orchestration rules.

### 6. Verify Against the Definition of Done
DoD fixed **before** execution (it is the Acceptance Matrix). **GREEN ≠ COMPLETE:** GREEN = the tests that exist pass over what was built; COMPLETE = every in-scope reference requirement traced to evidence and independently verified. A phase is done only if COMPLETE. **Verify audits the matrix, not the diff** — every in-scope row `built = yes` + real evidence + `verified-by ≠ executor` (run `independent-verifier` + `completeness-critic`). The `hooks/check-acceptance-matrix.sh` hook **blocks** "declare done"/PR while any in-scope row is untraced. Evidence before asserting; continuous per-unit verify throughout; full independent pass at the end.

See [references/verification.md](references/verification.md) for the method and domain examples.

### 7. Owner Sign-off
Human owner reviews verified output and signs off. Provide evidence, not assertions. Outstanding decisions and non-goals surfaced. Owner can cycle back to any earlier step.

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

Repetitive, mechanical, or high-volume tasks → automate with a tool, script, or program before spending AI capability or human effort. Reserve AI for design, grill, and decisions.

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

Full map: [agents/README.md](agents/README.md) · install the hook: [hooks/README.md](hooks/README.md).

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
- `grill-me` — adversarial review harness for Steps 3–4

These are accelerators, not requirements. The methodology stands on its own without them.
