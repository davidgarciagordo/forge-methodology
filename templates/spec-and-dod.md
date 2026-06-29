<!-- forge:spec -->
# Spec + Definition of Done — `[work name]`

> The spec is the single source of truth. **The Definition of Done lives canonically here, in the spec**
> — not in the plan, not in someone's head, not deferred to the final sign-off. A phase is done only when
> the Acceptance Matrix below is 100% satisfied for the in-scope rows.
>
> Copy this file into your repo (suggested path: `.forge/spec.md` or `docs/<feature>/spec.md`), fill every
> **required** section, and keep it versioned alongside the work. The `<!-- forge:spec -->` marker and the
> `## Acceptance Matrix` heading are load-bearing: the enforcement hook (`hooks/check-acceptance-matrix.sh`)
> parses them.

---

## 1. Value question — *required*

What problem does this actually solve, and for whom? One paragraph. If you cannot answer this, stop —
you are not ready to spec.

- **Problem:**
- **For whom:**
- **Why now:**

---

## 2. Reference Standard — *required*

Name the external benchmark this work is measured against, and **enumerate its in-scope capabilities as a
flat list**. This is the cure for "Done against ourselves, not against the goal": completeness is judged
against an *external, enumerated* reference, not against our own internal checklist.

The reference is a **named, inspectable thing**: a competitor product, a published spec, a regulation, an
RFC, a reference implementation, a screenshot set, a prior system being replaced. "Best practices" is **not**
a reference standard — it cannot be enumerated.

Choose exactly one of the two forms:

### Form A — there is a reference

> **Reference:** `[name + version/URL/section]` — e.g. "Twenty CRM v0.32, https://twenty.com, settings + workflows + custom-objects surfaces"

Enumerate every capability of the reference that is **in scope** for this work. One capability per line.
Each line gets a stable `req-id` (R1, R2, …) that the Acceptance Matrix and the plan reference by id.

```
R1  — [reference capability, named exactly as the reference names it]
R2  — [reference capability]
R3  — [reference capability]
…
```

> Produce this list with the **`reference-decomposer`** agent (it turns research/competitive analysis into
> the enumerated list) and the **`completeness-critic`** agent (it flags any reference capability missing
> from this list as a **blocking** finding). The list then *becomes* the Acceptance Matrix below — one
> artifact threaded research → spec → plan → verify.

### Form B — greenfield, no reference

> **Reference:** `GREENFIELD — no external reference.`
>
> Justify why no reference applies (genuinely novel; nothing comparable exists). Then enumerate the
> capabilities **from first principles** instead — the matrix still applies, the `fuente` column just reads
> `first-principles` instead of a reference section. Declaring greenfield is an explicit, reviewable choice,
> not a default to dodge the reference step.

---

## 3. Acceptance Matrix — *required* — the contract

Every in-scope capability from §2 becomes a row. **This table is the Definition of Done.** A phase / the
whole work is `COMPLETE` only when **every `in-scope = yes` row** has `built = yes`, non-empty `evidence`,
and a `verified-by` that is **not the executor**.

The enforcement hook parses this exact table. Keep the header columns and order:

## Acceptance Matrix

| req-id | fuente (ref §/screen) | in-scope? | built? | evidence (test/screenshot/link) | verified-by (≠ executor) |
|--------|----------------------|-----------|--------|---------------------------------|--------------------------|
| R1 | [ref §/screen or `first-principles`] | yes | no | — | — |
| R2 | [ref §/screen] | yes | no | — | — |
| R3 | [ref §/screen] | no | — | (out of scope — see Non-goals) | — |

**Column contract:**

- **req-id** — stable id from §2. Referenced by the plan's `Satisfies-reqs` field.
- **fuente** — where the requirement comes from: the reference section/screen, or `first-principles`.
- **in-scope?** — `yes` / `no`. A `no` row must be justified in §4 Non-goals.
- **built?** — `yes` / `no`. Only `yes` when the capability actually exists in the artifact.
- **evidence** — a *checkable* pointer: a test name/path, a screenshot file, a PR/commit link, a recorded
  run. `—`, `TODO`, `WIP`, `pending` count as **no evidence**. Required for every in-scope row.
- **verified-by** — the agent/person who confirmed the evidence, and who is **≠ the executor** that built
  it. Self-verification does not count (see `references/verification.md`, the self-verified-green failure).

> **DoD = every in-scope row is `built = yes` + has evidence + has an independent `verified-by`.** Nothing
> else is "done". Green tests on what exists is `GREEN`, not `COMPLETE`.

---

## 4. Non-goals — *required*

What is explicitly **out of scope** (every `in-scope = no` row above belongs here, with a reason). Cutting
scope is legitimate; cutting it *silently* is the failure this template prevents. Name what you are not
doing and why.

- **Out:** … — **because:** …

---

## 5. Constraints & trade-offs

Hard constraints (perf, security, compatibility, budget, deadline) and the trade-offs accepted.

---

## 6. Definition of Done (pointer)

The DoD is the Acceptance Matrix in §3 at 100% for in-scope rows, **plus** the domain pack's done-checklist
(see `references/domain-packs/<domain>.md`) and the universal rule in `references/verification.md`:

> **GREEN** = the tests that exist pass over what was built.
> **COMPLETE** = every in-scope requirement of the reference is traced to evidence and independently verified.
> A phase is done only if **COMPLETE**, never with **GREEN** alone.

---

## How this template is enforced (not advisory)

| Mechanism | What it does |
|-----------|--------------|
| `reference-decomposer` agent | Turns research/competition into the enumerated §2 list → matrix rows |
| `completeness-critic` agent | Runs on this spec **early** (and again at verify): a reference capability absent from the spec/plan is a **blocking** finding |
| `independent-verifier` agent | Audits the matrix at verify: one evidence check per in-scope row, `verified-by ≠ executor` |
| `visual-fidelity-checker` agent | For UI rows: side-by-side of each surface vs. the reference's equivalent screen |
| `hooks/check-acceptance-matrix.sh` | **Blocks** "declare done" / `gh pr create` if any in-scope row lacks `built=yes` + evidence + independent `verified-by` |

This makes completeness **mechanical**: it is checked by a hook and audited by an independent agent, not
left to the owner to notice at the final sign-off.
