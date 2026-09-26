# The Loop — Forge's 9-Step Cycle

**Contents**

- [Step 1 — Align Intent + Brainstorm](#step-1--align-intent--brainstorm)
- [Step 2 — Reference Decomposition](#step-2--reference-decomposition)
- [Step 3 — Draft + Grill ×3](#step-3--draft--grill-3)
- [Step 4 — Owner Checkpoint #1](#step-4--owner-checkpoint-1)
- [Step 5 — Versioned Spec](#step-5--versioned-spec)
- [Step 6 — Re-Grill ×2 (the spec)](#step-6--re-grill-2-the-spec)
- [Step 7 — Owner Checkpoint #2](#step-7--owner-checkpoint-2)
- [Step 8 — Global Plan + Execution Proposal](#step-8--global-plan--execution-proposal)
- [Step 9 — Execute → Verify → Sign-off](#step-9--execute--verify--sign-off)
- [The Adapt Principle](#the-adapt-principle)
- [Domain Packs](#domain-packs)

The core of Forge. Domain-agnostic: software, security, design, marketing, finance, research, operations.
The owner decides at exactly **two checkpoints** (steps 4 and 7), both as ONE multi-select batch with
recommendations pre-marked — everything else runs without interrupting them.

---

## Step 1 — Align Intent + Brainstorm

**Value question first:** what problem does this actually solve, and for whom?

- Surface the option space: 2–3 genuinely different approaches with trade-offs, not the first idea restated.
- Gather all high-impact decisions (scope, constraints, trade-offs, non-goals) from the owner in **one focused round** — not an infinite questionnaire.
- Surface misalignments between what was asked and what is actually needed.
- Hard gate: **nothing gets executed until intent is aligned.**

---

## Step 2 — Reference Decomposition

**Name the external reference the work will be measured against, and enumerate its in-scope capabilities
as a flat list.** The cure for "Done against ourselves, not against the goal."

- The reference is a **named, inspectable thing**: a competitor product, a published spec, an RFC, a
  regulation, a reference implementation, a screenshot set, the prior system being replaced. "Best
  practices" is not a reference — it cannot be enumerated.
- Turn whatever research / competitive analysis already exists into the enumerated list: one capability
  per line, each named as the reference names it, each with a stable `req-id` (R1, R2, …).
- **This single artifact threads forward**: the list *becomes* the Acceptance Matrix in the spec (step 5),
  every row maps to a work unit in the plan (step 8, via `Satisfies-reqs`), and verify audits it (step 9).
  One artifact, research → spec → plan → verify — not re-derived at each step.
- Genuinely novel work declares **greenfield (no reference)** explicitly and enumerates from first
  principles. Greenfield is a deliberate, reviewable choice — not a default to skip this step.

Run with the **`reference-decomposer`** agent; confirm nothing is missing with **`completeness-critic`**.
When writing the spec, put this output straight into the template [`../templates/spec-and-dod.md`](../templates/spec-and-dod.md).

---

## Step 3 — Draft + Grill ×3

Write the **draft**: the chosen approach worked into a concrete design/plan sketch (not yet the formal
spec). Then attack it — grilling the draft (cheap to change) before the spec (expensive to change) is the point.

- Run **three independent hostile lenses** on the draft. Always all three — never skip one because "it looks fine."
- **Add the fourth lens — Completeness vs Reference (`completeness-critic`) — whenever an external
  reference exists.** The first three hunt what *breaks*; the fourth hunts what is *missing*: an in-scope
  reference requirement not covered = **blocking** finding.
- **An unverified assumption is a finding.** A lens that can check something against reality (the actual
  system, data, constraints) must check it — not ask about what it can verify.
- Deep-reasoning tier; lenses are read-only.

The full method, the lens table by domain and the findings format live in `references/grill.md` (SKILL.md points there when grilling).

---

## Step 4 — Owner Checkpoint #1

Surface the grill's emergent decisions to the owner as **ONE multi-select batch** (`AskUserQuestion` or
the host's equivalent):

- Each item = a real decision the grill exposed, with your **recommended answer pre-marked** + the
  alternatives. The owner can accept, pick an alternative, add their own, or dispute.
- Never a stream of one-off questions; never a decision buried in prose.
- Run by the **orchestrator, never a grill subagent** — subagents cannot talk to the owner.

---

## Step 5 — Versioned Spec

Integrate draft + grill verdicts + owner decisions into the formal spec — the single source of truth.

- Version it (committed alongside the work, in a system with history).
- Specific enough that a third party could verify the outcome against it.
- **The Definition of Done lives canonically here, as the Acceptance Matrix**: every in-scope `req-id`
  from step 2 is a row (`req-id | source | in-scope? | built? | evidence | verified-by ≠ executor`), plus
  an explicit **Non-goals** section listing everything cut from scope. When
  starting the spec, copy [`../templates/spec-and-dod.md`](../templates/spec-and-dod.md). The DoD is fixed in the spec — never
  deferred to the plan or the final sign-off.

---

## Step 6 — Re-Grill ×2 (the spec)

Two focused passes over the SPEC — regression + novelty, not a third full grill:

1. **Do the fixes hold** — verify every checkpoint-#1 decision landed and survives attack.
2. **The new seams** — a fix in one place often opens a gap elsewhere; attack the edges the fixes create,
   and re-verify assumptions (including any "couldn't verify" findings) against the real system.

Repeat only until no new blocking or significant findings.

---

## Step 7 — Owner Checkpoint #2

Same mechanism as step 4: ONE multi-select batch with the re-grill outcomes and the remaining owner-only
calls (cut lines, phasing v1/v1.1/v2, budget), recommendations pre-marked. After this gate the spec is
**locked**.

---

## Step 8 — Global Plan + Execution Proposal

Before any execution begins: a plan covering **all work units, all phases, no gaps** — no "we'll figure
it out later."

The plan must include:
- Every work unit with declared inputs, outputs, ownership, and `Satisfies-reqs` (every in-scope `req-id`
  owned by at least one unit)
- The dependency graph; parallelizable vs. serial derived from it
- Acceptance criteria per phase; per-phase specs/plans written and versioned

Close with an explicit **execution proposal** — multi-agent by default when units are disjoint: isolated
worktrees per writer, ONE shared context pack (file:line), read-only + terse diagnosis lenses, the right
model tier per unit, deterministic tools before model effort. One line per phase; the owner already
decided everything else at the checkpoints.

**Grill the plan** (deep-reasoning tier) before locking it. Once locked, execution is mechanical.

Plan structure and execution modes live in `references/planning.md` and `references/execution-modes.md` (SKILL.md points there at step 8).

---

## Step 9 — Execute → Verify → Sign-off

### Execute

- Select work units from the plan's ready set — never improvise new work.
- Parallelize disjoint units in isolated workspaces; serialize where dependencies exist.
- Automate repetitive/mechanical tasks with tools or scripts before spending model or human effort;
  assign each unit its capability tier (deep-reasoning for decisions/review, execution tier for closed
  plans, fast tier for mechanical work).
- Checkpoint per phase/milestone so no session, quota, or interruption erases progress.
- A design question the plan did not answer → **stop the affected units**, return to grill/plan, update
  spec + plan, resume. Never improvise design mid-execution.

### Verify

> **GREEN ≠ COMPLETE.** GREEN = the tests that exist pass over what was built. COMPLETE = every in-scope
> requirement of the reference is traced to evidence and independently verified. **A phase is done only
> if COMPLETE, never with GREEN alone. Verify audits the Acceptance Matrix, not the diff.**

- **Audit the matrix**: every in-scope `req-id` is `built = yes`, with real evidence, signed off by a
  `verified-by` that is **not the executor**. Run the `independent-verifier` and `completeness-critic` agents.
- **Evidence before asserting**: never claim done without real output/data. The executor's own check does
  not count — get an independent pass.
- **Compare against baseline** on any failure: pre-existing (document, out of scope) vs. introduced
  (blocking regression).
- The `hooks/check-acceptance-matrix.sh` hook **blocks** "declare done" / opening a PR while any in-scope
  row is untraced — completeness is enforced, not trusted.

The full verification method and domain examples live in `references/verification.md` (SKILL.md points there at step 9).

### Owner sign-off

- Provide **evidence**, not assertions: the output, the verification results, the trade-offs made.
- Surface outstanding decisions and non-goals that were deferred.
- The owner can reject and cycle back to any earlier step.

---

## The Adapt Principle

Before starting any step, check whether its artifact already exists (a spec, a plan, prior art). If it
exists: **review it, grill it, refine it — do not recreate from scratch.** Skip or compress steps whose
output is already done and verified. Enter the loop at the right point.

### The non-skippable floor (Adapt reorders, it never deletes)

No matter how much prior art exists, **two things are never compressed away**:

1. **The Reference-matrix** — the enumerated reference (step 2) and its Acceptance Matrix in the spec. If
   prior art already has one, *reuse and verify* it; if not, produce it. "We're adapting an existing
   spec" is not a reason to skip enumerating the reference.
2. **The independent verify against the matrix** — the `independent-verifier`/`completeness-critic` pass
   and the GREEN ≠ COMPLETE gate (step 9). Existing tests passing does not substitute for it.

Adapt may merge, reorder, or fast-path any other step. Never these two.

---

## Domain Packs

Each domain instantiates the loop with its own grill lenses, definition of done, and verification steps.
Packs live in `references/domain-packs/` (SKILL.md's domain table picks the one to read) for software (backend, frontend, multi-agent), security, design,
marketing, finance, and brainstorming. For any other domain, derive the three lenses from the pattern in
`references/grill.md` (system view · human reality · technical depth) and fix the DoD before starting.
