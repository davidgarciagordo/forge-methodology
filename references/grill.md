# Grill — Adversarial Review Method

The grill is Forge's core quality gate. It is not a friendly review. Its job is to find what breaks.

---

## The Method

### How to run a grill

1. **Select three lenses** for the domain (see the table below). Each lens has a distinct hostile perspective.
2. **Run all three independently.** No lens sees the others' findings while it works.
3. **Each lens searches for failures**, not improvements. Its only question: *"What breaks? What has been assumed but not verified? What could go wrong?"*
4. **An unverified assumption is a finding.** When a lens can check something against reality (existing systems, actual data, real constraints, live environments), it must — instead of asking about what it can look up itself.
5. **Use the deep-reasoning tier.** The point is to catch what a surface read misses.

### Findings format

Each finding must include:

- **What breaks** — the failure mode, not just "this could be a problem"
- **Evidence** — where in the spec, system, data, or environment the problem appears; cite with specifics
- **Severity** — `blocking` / `significant` / `minor`

A finding of "I couldn't check this" is also valid — it surfaces a gap in the spec or in available information.

### After the grill

1. Address all blocking and significant findings in a **re-spec**.
2. Run a targeted **re-grill** focused only on:
   - The seams the fixes create (a fix in one place often opens a gap elsewhere)
   - Any findings marked "couldn't verify" that can now be checked
3. Repeat until green: no new blocking or significant findings.

---

## Lenses by Domain

The three lenses always cover the same three angles: **system view · human reality · technical depth**. What they focus on changes per domain.

| Domain | Lens 1 — System view | Lens 2 — Human reality | Lens 3 — Technical depth |
|--------|---------------------|----------------------|--------------------------|
| **Software** | Platform Architect — rules, bounded contexts, precedents verified against actual code (location + reference) | Real Operator/User — day-to-day cases, what breaks at the counter, edge cases in practice | Domain Engineer — concurrency, race conditions, what fails in production under load |
| **Security** | Attacker — exploitable paths, privilege escalation, data exposure | Defender / Incident Responder — detection, containment, blast radius of a breach | Compliance/Audit — regulatory obligations, evidence requirements, what auditors look for |
| **Design** | User/Usability — does the hierarchy and flow match how real users think? What gets missed? | Accessibility — assistive technology, contrast, keyboard navigation, WCAG | Brand/System — does it fit the design system? What breaks when scaled across all surfaces? |
| **Marketing** | Customer/Audience — does the message match what the target audience actually believes? What objection is unanswered? | Skeptic — what makes this unbelievable or forgettable? What competitor does this better? | Brand/Legal — compliance, claim substantiation, regulatory constraints |
| **Finance** | Auditor — does the model reconcile? What assumption isn't substantiated? | Risk — what scenario breaks this? What are the tail risks? | Stakeholder/Decision-maker — what decision does this enable, and is the data reliable enough? |
| **Research** | Methodology — is the research design valid? What introduces bias or confounds? | Domain Expert — what does the field already know that contradicts this? | Reproducibility — can this be independently verified? What would disprove it? |
| **Operations** | Process Architect — where are the handoffs that will fail? What isn't owned? | Frontline/Operator — what breaks in the real workflow under time pressure? | Resilience/Recovery — what happens when this step fails? Can it be recovered without data loss? |
| **Brainstorming/Strategy** | Critic — what assumption underlies this idea and is it true? | Alternative view — what is the strongest counter-argument or competing approach? | Feasibility — what would it actually take to execute this, and is that realistic? |

> **Note:** the lenses above are starting points. Adapt them to your domain. Three lenses covering the same angle are weaker than three genuinely different perspectives.

---

## Grill Depth

Grill depth should be proportional to **novelty × blast radius**:

| Novelty | Blast radius | Recommended depth |
|---------|-------------|-------------------|
| Low | Low | Single-pass in execution tier; escalate disputed findings to deep-reasoning tier |
| High or unknown | Any | Full three-lens grill in deep-reasoning tier |
| Any | High | Full three-lens grill + re-grill after fixes |

Skip re-grill on artifacts that are already verified. Only re-grill the new seams.

---

## The Key Principle

> **An unverified assumption is a finding.**

A lens that says "I assume X is true" without checking has not done its job. When a lens can verify something — by reading the existing system, the actual data, the live environment — it must do so and report what it found, not what it assumed.
