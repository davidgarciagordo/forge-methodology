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

## Step 1.5 — Reference Decomposition (between Align and Spec)

Before writing the spec, **name the external reference the work will be measured against, and enumerate its
in-scope capabilities as a flat list.** This is the cure for the most expensive *completeness* failure:
"Done against ourselves, not against the goal" — where a team judges completeness against its own internal
checklist and ships short of the reference it promised parity with.

- The reference is a **named, inspectable thing**: a competitor product, a published spec, an RFC, a
  regulation, a reference implementation, a screenshot set, the prior system being replaced. "Best
  practices" is not a reference — it cannot be enumerated.
- Take whatever research / competitive analysis already exists and **turn it into an enumerated list**: one
  capability per line, each named as the reference names it, each with a stable `req-id` (R1, R2, …).
- **This single artifact threads forward**: the enumerated list *becomes* the Acceptance Matrix in the spec
  (Step 2), every row maps to a work-unit in the plan (Step 4, via `Satisfies-reqs`), and verify audits it
  (Step 6). One artifact, research → spec → plan → verify — not re-derived at each step.
- If the work is genuinely novel, declare **greenfield (no reference)** explicitly and enumerate from first
  principles instead. Greenfield is a deliberate, reviewable choice — not a default to skip this step.

Run this with the **`reference-decomposer`** agent (reference → enumerated list) and confirm nothing is
missing with the **`completeness-critic`** agent. Output goes straight into the spec template
([`../templates/spec-and-dod.md`](../templates/spec-and-dod.md)).

---

## Step 2 — Write a Versioned Spec

Produce a written artifact that both the human and the AI agree on. This becomes the single source of truth.

- Version it (committed to a repo, a document store, or any system with history).
- Make it specific enough that a third party could verify whether the outcome meets it.
- Keep it alongside the work it describes.
- **The Definition of Done lives canonically here**, as the **Acceptance Matrix**: every in-scope `req-id`
  from Step 1.5 is a row (`req-id | source | in-scope? | built? | evidence | verified-by ≠ executor`), plus
  an explicit **Non-goals** section listing everything cut from scope. Use
  [`../templates/spec-and-dod.md`](../templates/spec-and-dod.md). The DoD is not deferred to the plan or to
  the final sign-off — it is fixed in the spec, before execution.

---

## Step 3 — Adversarial Grill (+ Respond / Refine Loop)

Run **three independent hostile lenses** on the spec. This is not a friendly review — each lens looks for things that break.

**Rules for the grill:**
- Always run all three lenses. Never skip one because "it looks fine."
- **Add the fourth lens — Completeness vs Reference — whenever the work is measured against an external reference.** The first three hunt what *breaks*; the fourth hunts what is *missing*. Its axiom mirrors the first: **a reference requirement not covered is a finding** (blocking for any in-scope capability absent from the spec/plan). It runs as the `completeness-critic` agent.
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

**Fix the definition of done before execution begins** (it is the Acceptance Matrix in the spec). During execution, verify continuously per work unit; run a full independent verification at the end.

> **GREEN ≠ COMPLETE.** GREEN = the tests that exist pass over what was built. COMPLETE = every in-scope
> requirement of the reference is traced to evidence and independently verified. **A phase is done only if
> COMPLETE, never with GREEN alone.** Verify audits the **Acceptance Matrix**, not the diff.

- **Audit the matrix**: every in-scope `req-id` must be `built = yes`, with real evidence, signed off by a `verified-by` that is **not the executor**. Run the `independent-verifier` and `completeness-critic` agents.
- **Evidence before asserting**: never claim done without real output/data showing it.
- **Independent verification**: the executor's own check does not count. Get a second, independent pass.
- **Compare against baseline**: when something fails, determine whether it was pre-existing or introduced.

The `hooks/check-acceptance-matrix.sh` hook blocks "declare done" / opening a PR while any in-scope row is untraced — completeness is enforced, not trusted.

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

### The non-skippable floor (Adapt reorders, it never deletes)

Adapt is not an escape hatch. No matter how much prior art exists, **two things are never compressed away**:

1. **The Reference-matrix** — the enumerated reference (Step 1.5) and its Acceptance Matrix in the spec. If
   prior art already has one, *reuse and verify* it; if it does not, you must produce it. "We're adapting an
   existing spec" is not a reason to skip enumerating the reference.
2. **The independent verify against the matrix** — the `independent-verifier`/`completeness-critic` pass
   (Step 6) and the GREEN ≠ COMPLETE gate. Existing tests passing does not substitute for it.

Adapt may merge, reorder, or fast-path other steps. It may never delete these two. They are the floor that
keeps "Adapt the Pipeline" from becoming "skip the part that proves we're done."

---

## Domain Packs

Each domain instantiates the loop with its own grill lenses, definition of done, and verification steps.

See [domain-packs/](./domain-packs/) for software, security, design, marketing, finance, brainstorming, and operations instantiations.
