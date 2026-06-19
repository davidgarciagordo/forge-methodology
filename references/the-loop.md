# The Loop — Forge's Universal 7-Step Cycle

This is the core of Forge. Every step applies regardless of domain: software, security, design, marketing, finance, research, operations.

---

## Step 1 — Align Intent

**Lead with the value question first.** Before any work begins, answer: *What problem does this actually solve, and for whom?*

- Gather all high-impact decisions (scope, constraints, trade-offs, non-goals) from the owner in **one focused round** — not an infinite questionnaire.
- Surface misalignments between what was asked and what is actually needed.
- Hard gate: **nothing gets executed until intent is aligned and the design is approved.**

> The most expensive mistake is executing the wrong thing thoroughly.

---

## Step 2 — Write a Versioned Spec

Produce a written artifact that both the human and the AI agree on. This becomes the single source of truth.

- Version it (committed to a repo, a document store, or any system with history).
- Make it specific enough that a third party could verify whether the outcome meets it.
- Keep it alongside the work it describes.

---

## Step 3 — Adversarial Grill (+ Respond / Refine Loop)

Run **three independent hostile lenses** on the spec. This is not a friendly review — each lens looks for things that break.

**Rules for the grill:**
- Always run all three lenses. Never skip one because "it looks fine."
- An **unverified assumption is a finding.** When a lens can check something against reality (the actual system, the actual data, the actual constraints), it must — not ask about what it can verify.
- Use the **deep-reasoning tier** (the most capable model or analyst available).

**After the grill:**
- Address all findings → produce a **re-spec**.
- Run a targeted **re-grill** focused only on the new seams the fixes create.
- Repeat until green (no new findings of substance).

See [grill.md](./grill.md) for the full method, lens definitions by domain, and the findings format.

---

## Step 4 — Global Plan

Before any execution begins, produce a **global plan covering all work units** — no gaps, no "we'll figure it out later."

**The plan must include:**
- Every work unit with declared inputs, outputs, and ownership (who/what does it)
- The dependency graph: which work units depend on which outputs
- Which phases are parallelizable and which are serial (derived from the dependency graph)
- Acceptance criteria per phase

**Grill the plan** (deep-reasoning tier) before locking it. Once locked, execution is mechanical.

See [planning.md](./planning.md) for the global plan structure and the work-unit ownership model.

---

## Step 5 — Execute Optimally

With the plan locked, execution is about optimizing **how** the work gets done:

- **Parallelize disjoint work units** — units with no shared ownership or dependencies run simultaneously.
- **Automate repetitive / mechanical tasks** with tools, scripts, or dedicated programs before spending AI capability or human effort on them.
- **Assign each work unit to the right capability tier**: deep-reasoning for decisions and critical review, execution tier for closed plans and high-volume work, fast tier for mechanical tasks.
- **Checkpoint regularly**: persist work per phase/milestone so no session, quota, or interruption can erase progress.
- **Serialize when there are dependencies**: if work unit B needs output from A, run them in order.
- **When doubts arise during execution**: return to the plan / grill step to resolve — do not improvise design mid-execution.

See [execution-modes.md](./execution-modes.md) for detailed orchestration rules.

---

## Step 6 — Verify Against the Definition of Done

**Fix the definition of done before execution begins.** During execution, verify continuously per work unit; run a full independent verification at the end.

- **Evidence before asserting**: never claim done without real output/data showing it.
- **Independent verification**: the executor's own check does not count. Get a second, independent pass.
- **Compare against baseline**: when something fails, determine whether it was pre-existing or introduced.

See [verification.md](./verification.md) for the full method, domain examples, and the done-checklist format.

---

## Step 7 — Owner Sign-off

The human owner reviews the verified output and signs off. This is the final gate.

- Provide **evidence** (not just assertions): show the output, the verification results, and any trade-offs made during execution.
- Surface outstanding decisions or non-goals that were deferred.
- Owner can reject and cycle back to any earlier step.

---

## The Adapt Principle

**Intelligence = adapting the loop to what already exists, not recreating it from scratch.**

Before starting any step, check whether its artifact is already done (a spec exists, a plan exists, prior art exists). If it exists: **review it, grill it, refine it**. Skip or compress steps whose output is already done and verified. Enter the loop at the right point.

---

## Domain Packs

Each domain instantiates the loop with its own grill lenses, definition of done, and verification steps.

See [domain-packs/](./domain-packs/) for software, security, design, marketing, finance, brainstorming, and operations instantiations.
