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

---

## The Loop (7 Steps)

Full detail in [references/the-loop.md](references/the-loop.md).

### 1. Align Intent
Lead with the **value question first**: what problem does this actually solve and for whom? One focused round with the owner. Explicit decisions on scope, constraints, trade-offs, non-goals. Hard gate: **nothing gets executed until intent is aligned.**

### 2. Write a Versioned Spec
A written artifact — both human and AI agree on it. Specific enough that a third party could verify whether the outcome meets it. Versioned and kept alongside the work.

### 3. Adversarial Grill
Three independent hostile lenses review the spec. **An unverified assumption is a finding.** Deep-reasoning tier. After: respond → re-spec → re-grill on new seams → repeat until green.

See [references/grill.md](references/grill.md) for the full method and lens table by domain.

### 4. Global Plan
All work units, all phases, no gaps — **before any execution begins.** Dependency graph computed. Parallelizable vs. serial derived from the graph. Grill the plan before locking it.

See [references/planning.md](references/planning.md) for the plan structure and work-unit template.

### 5. Execute Optimally
Parallelize disjoint work units, each in its **own isolated workspace** (a branch + worktree, or a per-unit sandbox) so parallel writers never collide on disk. Share **one context pack** (key locations with file:line, decisions, vocabulary) so no agent re-discovers what another already found. Select the next unit from the plan's ready set — never improvise. Automate repetitive/mechanical tasks with tools before spending AI capability. Right capability tier per work unit. Checkpoint per phase.

See [references/execution-modes.md](references/execution-modes.md) for orchestration rules.

### 6. Verify Against the Definition of Done
Definition of done fixed **before** execution. Evidence before asserting. Independent verification (not the executor's own check). Continuous per-unit verify throughout; full independent pass at the end.

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

### Specs and Plans are Versioned Artifacts

They live alongside the work, committed. Work survives the session (checkpoint per phase/milestone).

### Disagree With Data

Disagreeing with the plan — with evidence and reasoning — is part of the role. Raise it early, with specifics.

---

## Templates

- [templates/work-unit-plan.md](templates/work-unit-plan.md) — declare a work unit in the plan
- [templates/state-capsule.md](templates/state-capsule.md) — resume capsule per workstream
- [templates/phase-gate-checklist.md](templates/phase-gate-checklist.md) — gate a phase before advancing

---

## Optional Accelerators (Claude Code)

Forge is self-contained and works with any AI assistant or human team. In **Claude Code**, several skills automate parts of the pipeline:

- `superpowers:brainstorming` — structured facilitation for Step 1
- `superpowers:writing-plans` — guided planning for Step 4
- `grill-me` — adversarial review harness for Steps 3–4

These are accelerators, not requirements. The methodology stands on its own without them.
