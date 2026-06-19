# Forge — Finance Pack

> Domain pack for Forge methodology. Instantiates the universal 7-step loop for financial modeling, analysis, reporting, and decision support.
> Core references: [the-loop.md](../the-loop.md) · [grill.md](../grill.md) · [verification.md](../verification.md)

---

## Grill Lenses for Finance

| Lens | Perspective | Focus |
|------|------------|-------|
| **Auditor** | System view | Does the model reconcile? Are all inputs traceable to source data? Are formulas correct and consistent? What assumption is stated as fact but has not been verified against actual data? |
| **Risk Analyst** | Technical depth | What scenario breaks this model? What are the tail risks and how sensitive is the output to them? What has been optimized for the base case at the cost of resilience to downside scenarios? |
| **Stakeholder / Decision-maker** | Human reality | What decision does this analysis enable? Is the data reliable enough to make that decision? Are the outputs presented in a way that supports the right decision, or could they be misread to support the wrong one? |

---

## Definition of Done — Finance

Financial work is done when **all** of the following are true:

- [ ] Model reconciles to source data (totals tie, no unexplained variances)
- [ ] All input assumptions are documented with their source and the date they were last verified
- [ ] Sensitivity analysis completed: key outputs tested under pessimistic, base, and optimistic scenarios
- [ ] Key risks identified and quantified (or explicitly noted as unquantifiable)
- [ ] Results reviewed by someone other than the model builder (independent check)
- [ ] Outputs are presented in a format appropriate to the decision they support
- [ ] No hardcoded values that should be parameterized (rates, prices, headcount — use named cells/variables)
- [ ] Audit trail: version history or change log shows how the model evolved

---

## What to Verify

### Reconciliation
- Does the model tie to source data? Sum the inputs; confirm they match the source.
- Are interlinked sheets / sections self-consistent? A change in one place propagates correctly.
- Are all formulas stable (no circular references, no silent errors, no cells that should be formulas but are hardcoded values)?

### Assumptions
- Every key assumption has a documented source and a "last verified" date
- Rate assumptions (interest rates, growth rates, exchange rates) are current or explicitly marked as fixed-date
- No assumption is load-bearing without a sensitivity test showing how the output changes if the assumption is wrong

### Scenario analysis
- Base case, downside, and upside scenarios are explicitly modeled
- The downside scenario is not just "slightly worse" — it tests a realistic adverse outcome
- Break-even analysis: what does the input need to be for the outcome to flip sign?

### Presentation
- Outputs support the stated decision — not a different, easier-to-answer question
- Uncertainty is communicated, not hidden (ranges, not just point estimates, where appropriate)
- Key assumptions are visible to the reader, not buried in a footnote

---

## Finance Principles

- **Source before model.** An assumption not traced to a source is an opinion. Label it as such.
- **Reconcile before building.** If the inputs do not tie, stop and fix before building the model on top of them.
- **Parameterize assumptions.** Values that represent real-world rates, prices, or estimates belong in named cells or variables — not hardcoded into formulas where they become invisible.
- **The decision comes first.** Design the model around the decision it needs to support, not around the data that is conveniently available.
- **Independent review is not optional.** The model builder is the last person to find their own errors. A second reviewer catches what familiarity blinds.
