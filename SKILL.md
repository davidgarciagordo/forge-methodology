---
name: forge-methodology
description: Disciplined pipeline for substantial software work with AI agents — spec → adversarial grill (×3 lenses) → global plan → parallel execution (model-per-task, isolated worktrees) → green verify → visual gate. Apply to any new feature, architectural change, large refactor, or migration. Skip for trivial one-liners.
---

# Forge — Methodology for Substantial Software Work with AI Agents

> **"Run it through the Forge"** = apply this pipeline. Use for any substantial work: new features, architectural changes, large refactors, migrations. Go direct for trivials (one-liners, formatting). Distills and integrates brainstorming, spec, adversarial review, plan, parallel execution, and verification into one named workflow.

---

## Adapt the Pipeline to What Already Exists

**Intelligence = adapting the procedure to what already exists, not recreating it.** Before starting any phase, check whether its artifact is already done (spec, plan, infra, script, deploy). If it exists: **review it, grill it, refine it — do NOT recreate from scratch.** Skip or compress phases whose output is already done and verified; reuse, don't duplicate work. The pipeline below is the full form for new work; for existing work, enter at the right point (re-grill the spec, review the plan, fix the code).

---

## The Pipeline

### 1. Brainstorm
Use the `brainstorming` skill. Lead with the **value question first**. Gather all high-impact decisions from the user in **one focused round** — not an infinite questionnaire. Hard gate: nothing gets implemented until the design is approved.

### 2. Versioned Spec
Write the spec as a committed file in the repo (e.g., `docs/specs/<feature>.md`). This is the source of truth going forward.

### 3. Adversarial Grill ×3 (Opus)
Run three independent lenses on the spec — **always all three**:

- **Platform Architect** — rules, bounded contexts, **precedents verified against actual code (file:line)**. An unverified assumption is a finding. Explores the code instead of asking what it can check.
- **Real Operator / User** — day-to-day cases, edge cases at the counter, what breaks in practice.
- **Domain Engineer** — concurrency, edge cases, what fails in production.

### 4. Respond / Refine → Re-spec → Re-grill
Address findings with Opus → produce **re-spec** → run a new grill targeted at the **seams the fixes create**. Repeat until green.

### 5. Global Master Plan (writing-plans)
Use `writing-plans` (superpowers skill) to produce the **global master plan covering ALL phases** (v1, v1.1, v2…) with specs and plans per phase, no gaps, **before any execution begins**. Grill the plan (Opus). Once the global plan is locked, execution becomes mechanical.

### 6. Parallel Execution in Workflows

Run agents in parallel with these constraints:

- **Unified memory**: Phase 1 produces a context pack with **file:line** references; results are chained between phases. **DISJOINT areas between agents** — one file, one owner.
- **Model per task**: Opus leads/decides/grills/reviews the critical; Sonnet executes closed plans/refactors/migrations; Haiku handles trivials.
- **Terse communication** between agents (code/commits/security always in correct full prose).
- **Isolated worktrees**: 1 session = 1 worktree = 1 branch, plus **per-phase commits** so work survives the session.
- **If doubts arise during execution** → return to writing-plans/grill with Opus to resolve and re-spec. Do not improvise architecture.

### 7. Green Verify — Before Declaring Done

**Never declare done without evidence.** Run all of:

- `typecheck` + full test suite + parity checks
- Domain reviewers (migration-reviewer, tenant-isolation-reviewer, etc.) if the change touches the DB or shared state
- **Live verification** (browser/devtools, light/dark/mobile — no screenshot = not done)

> "Green" = full typecheck + full suite. Not just the area the worker touched.

### 8. Visual Gate + Merge

Visual-gate all UI surfaces before merge. **Merge only when green + gated.** Always review before merge. Clean up branch/worktree/claim on merge.

---

## Execution & Orchestration Layer

Forge designs well (grill, spec, plan). These rules optimize **cost and reliability** when running multiple agents in parallel. Treat **quota, account tier, and file ownership as first-class resources** — not surprises.

### 1. Quota + Tier-Aware Scheduling

Before executing, build an **account ledger** (tier × session window × current burn). Route:

- Heaviest/most critical workstreams → highest tier
- Light work / review / reserve → lower tier

**Checkpoint + migrate preventively at ~80% of the window**, never reactively at the limit. Always keep **one account in reserve** to inherit a workstream if another hits its limit — resume in the **same worktree**, never from scratch.

### 2. File-Ownership Graph in the Master Plan

Each phase declares **files it writes + files it depends on**. The orchestrator computes the parallelizable schedule and **detects cross-cutting files upfront** (e.g., lock files, shared config, i18n) → assign a single "integrator" for shared files, or serialize only those touches. "Disjoint areas" becomes a calculated constraint, not a wish.

### 3. Continuous Per-Phase Verify — Not Just at the End

Each phase commit triggers a **cheap parallel verify** (typecheck + diff tests + domain reviewers if touching DB), model-tiered. Catch regressions in phase N, not in the PR of phase N+10.

> Lesson learned: a worker reported "250 passing" running only its own tests; the final verify found broken typecheck + 6 HIGH findings. **Evidence before asserting; "green" = full typecheck + full suite, not just the worker's area.**

### 4. Adaptive Tiered Grill

Grill depth ∝ **novelty × blast radius**. First pass in Sonnet; escalate to Opus only for disputed/architectural findings. Skip re-grill on already-verified artifacts (= "adapt the pipeline" principle). Cuts the biggest Opus spend without losing rigor on the seams.

### 5. Cheap Orchestrator

Routine coordination (commit tracking, handoff docs, status updates) = **scripted / Haiku / monitor**, not Opus. Opus decides: rebalancing, arbitration, grill, critical review. The "model per task" rule applies to the orchestrator too.

### 6. Resume Capsule + WIP Commits

Each workstream keeps a committed **`state.md`** (done / next / files-in-flight / decisions) → resume = read 1 file, not re-derive from plan+spec+git. **Sub-phase WIP commits** prevent losing in-progress work when a session limit hits.

### 7. Batched Visual Gate + Everything in Storybook

Every UI component gets a story file (`.stories.tsx` or equivalent). Accumulate screenshots (light/dark/mobile) from **all surfaces** into **one gate queue** → the owner reviews many at once, async, instead of stalling per PR. Pages and data-fetching components that can't be storied get gated live.

### 8. Phase Granularity = "Losable Without Pain"

Each phase should be ≤ 1 reviewable commit / ~1-2h of work. Mark in the plan which phases are **parallelizable vs serial** (derived from the file-ownership graph in rule #2).

---

## Hard Rules for Multi-Account / Multi-Worker Orchestration

- **1 worktree = 1 worker = 1 branch** — no exceptions.
- Verify a worker is dead **by PID and actual prompt**, not by naive `grep | wc` (a false negative can launch a second worker in the same worktree → two writers racing).
- When killing a worker, kill the whole process tree (parent shell + `claude -p` process + any `stream-json` / build subprocesses).
- Launch headless with `--permission-mode acceptEdits` + an explicit tool allowlist (git, package managers, node). **Never `--dangerously-skip-permissions`.**
- **Infra FREE**: zero billable resources created without explicit approval.

---

## Product Completeness Gates

A product is **not complete** without:

- Its **landing page / marketing entry point**
- Its **product documentation file** in the docs directory
- Its **operator panel section** (availability, gating, metering)
- **Stories for all UI components**

Plan these as phases, not afterthoughts.

---

## Cross-Cutting Principles

### ⭐ Model Per Task (CRITICAL)

**Always match the model to the work:**

| Model | Use for |
|-------|---------|
| **Haiku** | Trivial / mechanical: one-liners, formatting, stubs, minor tweaks |
| **Sonnet** | Executing closed plans, refactors, migrations, high-volume work |
| **Opus** | Only what determines the outcome: architecture, grill, arbitration, critical review, ambiguity |

Don't use a sledgehammer for a nail: no Opus where Sonnet or Haiku performs equally well. Applies to every agent in a workflow, including the orchestrator. This is **cost ↔ quality priority #1.**

### ⭐ Automate Repetitive Work with Scripts Before Spending Tokens

If a task is repetitive, mechanical, or high-volume (a sweep, a count, a migration, a search, a rename), **write a bash/python script or use `grep`/`rg`/`sed`/`jq`/ a battle-tested library** instead of iterating token by token. Deterministic, fast, and cheap. Reserve tokens for thinking (design, grill, decisions) — not for what a tool does better.

Examples:
- `grep` / `rg` to locate usages across the codebase
- A bash for-loop to process N files
- A registry library instead of hand-rolling a utility

### Reuse-First / DRY / SOLID / KISS / Atomic Design — at Every Layer, from Day 1

Before writing something that will be repeated, create the **reusable primitive** (helper / port / component / wrapper) and use it. Cross-cutting concerns (auth, API fetch, logging, errors, i18n) → **one central point**, never duplicated across N files. Thinking about reuse is part of design, not an afterthought.

> Example lesson: a codebase with dozens of direct `fetch()` calls scattered everywhere instead of a single `apiFetch()` wrapper — every error-handling change became a sweep.

### Versioned Specs and Plans

Specs and plans live in the repo, committed. Work survives the session (commit per phase/milestone).

### Don't Repeat Work Without Reason

Don't re-read entire files, don't re-run full test suites, don't repeat audits already done without a reason. Spend tokens where they add value.

### Disagree With Data

Disagreeing with the plan — with evidence and reasoning — is part of the role. Commercial naming and brand decisions belong to the owner; bounded contexts and code stay in English.
