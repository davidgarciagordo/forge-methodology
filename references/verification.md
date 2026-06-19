# Verification — Defining and Proving Done

Verification in Forge has one hard rule: **fix the definition of done before execution begins**, then hold to it.

---

## The Definition of Done

Write the definition of done as part of the spec (Step 2) or the plan (Step 4). It must be:

- **Specific**: a third party can check it without asking for clarification.
- **Complete**: it covers all dimensions of correctness, not just the happy path.
- **Independent**: it can be verified by someone or something other than the executor.

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
