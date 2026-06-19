# Phase Gate Checklist Template

Use before marking a phase complete and moving to the next. Adapt the domain-specific sections to your domain pack.

---

## Universal Gate (all domains)

- [ ] All work units in this phase have met their declared acceptance criteria
- [ ] Outputs from this phase are versioned / committed / persisted — not just in memory or a local working copy
- [ ] Independent verification has been run (not just the executor's own check)
- [ ] Verification results are documented (output, test report, review notes — not just "it passed")
- [ ] No blocking findings from verification are outstanding
- [ ] Resume capsule (`state.md` or equivalent) is updated with this phase marked done
- [ ] Dependencies for the next phase are confirmed ready (all required inputs exist)

---

## Domain-Specific Additions

### Software
- [ ] Typecheck green (full, not just the changed area)
- [ ] Test suite green (full suite, not just the changed module's tests)
- [ ] No regressions vs. baseline (compared against the base/main state)
- [ ] Security checklist cleared if the change touches auth, data access, or external boundaries

### Design
- [ ] All required states designed (default, empty, loading, error, disabled, overflow)
- [ ] Accessibility review completed (contrast, keyboard, screen reader)
- [ ] Owner visual review completed (screenshots at all themes and breakpoints)

### Finance
- [ ] Model reconciles to source data
- [ ] Key assumptions documented with sources
- [ ] Sensitivity analysis completed

### Marketing
- [ ] Claims verified and substantiated
- [ ] Legal/compliance review completed
- [ ] Metrics for this phase defined and measurable

### Security
- [ ] Threat vectors identified and addressed
- [ ] No secrets in version-controlled artifacts
- [ ] Evidence collected for compliance requirements

### Research
- [ ] Sources reviewed and cited
- [ ] Key claims cross-checked against existing literature
- [ ] Methodology reviewed for validity

---

## Sign-off

```
Phase:          [name]
Gate completed: [date]
Verified by:    [person or process — must be independent from the executor]
Notes:          [any deferred items, known limitations, or decisions made during this phase]
```

---

## Notes on using this checklist

- **Do not skip the independence requirement.** The executor marking their own work as done is not a gate.
- **Adapt, do not omit.** If a domain-specific check does not apply, note why — do not silently skip it.
- **Blocking findings stop the phase.** Do not advance to the next phase with outstanding blocking findings; fix them first.
