# Verification — Defining and Proving Done

Verification in Forge has one hard rule: **fix the definition of done before execution begins**, then hold to it.

---

## GREEN ≠ COMPLETE (the first-class axiom)

> **GREEN** = the tests that exist pass over what was built.
> **COMPLETE** = every in-scope requirement of the reference is traced to evidence and independently verified.
> **A phase is done only if COMPLETE — never with GREEN alone.**

This is the axiom this whole reference is built around, because the failure it prevents is real and
expensive: a build passed its own tests (GREEN), was declared done, and shipped missing whole capabilities
the reference had — caught only at the owner's final sign-off, never at verify. GREEN measures the tests you
*chose to write*; it says nothing about the requirements you *never covered*.

The consequence for how you verify:

> **Verify audits the Acceptance Matrix, not the diff.** The question is never "do my tests pass?" It is
> "is every in-scope row of the matrix `built = yes`, backed by real evidence, and signed off by someone who
> is not me?" A green suite over an incomplete matrix is not done.

Verification therefore runs against the **Acceptance Matrix** in the spec (see
[`../templates/spec-and-dod.md`](../templates/spec-and-dod.md)) using the **`independent-verifier`** agent
(row-by-row evidence audit, verifier ≠ executor) and the **`completeness-critic`** agent (hunts any reference
capability missing from the matrix). The `hooks/check-acceptance-matrix.sh` hook blocks "declare done" / PR
while the matrix is not 100% traced — so COMPLETE is machine-checked, not advisory.

---

## The Definition of Done

The Definition of Done lives **canonically in the spec (Step 2)**, as the Acceptance Matrix — not in the
plan, not in someone's memory, not deferred to the final sign-off. The plan and verification *reference* it;
they do not redefine it. It must be:

- **Specific**: a third party can check it without asking for clarification.
- **Complete**: it covers **every in-scope capability of the reference** (the Acceptance Matrix is the list),
  not just the happy path.
- **Independent**: every row is verified by someone or something other than the executor.

> The matrix *is* the DoD. "Done" = every in-scope row built + evidenced + independently verified. Tests
> green on what exists is a *subset* of evidence, not the whole of done.

---

## Definition of Done by Domain

| Domain | Done means... |
|--------|--------------|
| **Software** | Typecheck passes + full test suite green (not just the changed area) + all integration points verified + no regressions vs. baseline |
| **Finance** | Model reconciles to source data + all scenarios check out + key assumptions are documented and substantiated |
| **Marketing** | Message tested with a representative sample of the target audience + key metrics defined and measurable + legal/compliance cleared |
| **Security** | All identified threat models addressed + adversarial review passed + compliance requirements met + evidence logged |
| **Design** | Usability tested per defined criteria + accessibility checked + design-system consistency verified + owner gate passed |
| **Research** | Methodology reviewed for validity + key claims cross-referenced with existing literature + findings independently reproducible |
| **Operations** | Process tested under realistic conditions + failure modes documented + handoffs verified with all stakeholders |

---

## Evidence Before Asserting

> **Never claim done without evidence.**

The executor's own assessment — "I think it's done", "it should work", "I checked it" — does not count as evidence. Evidence is:

- The actual output (the artifact, the result, the report)
- Independent verification (a check run by something other than the executor)
- A comparison against the pre-set definition of done, point by point

### The self-verified-green failure

A common failure mode: an executor runs its own check, reports "all done / all green", and the work is accepted. A later independent check finds critical failures.

The fix: require **independent verification** — a check run by a separate process, agent, or person that is not the original executor.

> **War story (software):** An agent ran its assigned test area and reported "250 tests passing." An independent verify pass found a typecheck failure (not covered by the agent's test run) and 6 significant issues the agent had never executed. "Green" meant "my area," not "the system." The definition of done must specify scope and independence.

---

## Baseline Comparison — Regression vs. Pre-existing

When a verification check fails:

1. **Check the baseline**: does this failure exist on the base/main/reference state, before your changes?
2. If **yes** → pre-existing issue. Document it; do not fix it in this change (out of scope); do not count it against your definition of done.
3. If **no** → regression introduced by this work. This is a blocking finding.

Never silently ignore a failure because "it was probably already there." Verify against the baseline.

---

## The Stale-Check Principle

If a change causes an existing verification check to fail:

1. Confirm whether the **real invariant** the check was protecting is still preserved.
2. If yes and the check is now stale (it was testing an implementation detail that legitimately changed) → update the check.
3. If no → fix the work, not the check.
4. **Never silence a check** (disable, comment out, skip) to make verification pass. That turns "green" into "untested."

---

## Continuous Per-Unit Verification

Don't wait until the end of all execution to verify:

1. After each phase or work unit completes, verify it against its acceptance criteria.
2. If it fails → fix before moving to the next dependent unit.
3. A defect caught at phase N is cheap to fix. The same defect discovered at phase N+10 is expensive.

This applies in all domains:
- Software: typecheck + tests after each phase commit
- Finance: reconcile each model section before building on top of it
- Marketing: review each asset before it becomes a dependency for the next
- Design: validate each component before composing it into larger screens
