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

> When a **human owns the call**, run the **user gate** before the re-grill — see *Running the Grill Interactively* below.

---

## Running the Grill Interactively

The grill runs **automatically** — three lenses, no interruptions. But automatic convergence hides the
moments where a human judgement would change the outcome. Two gates make those moments explicit
**without slowing the machine down**:

```
A. Entry gate         → high-impact clarifiers, grounded in the code + the brief, as ONE batch.
B. Grill ×3           → the three lenses run automatically. No user interruption.
C. User gate          → the doubts the grill surfaced, each with a recommended answer + alternatives,
                        presented for the human to accept / change / add to / dispute — as ONE batch.
D. Informed re-grill  → one more automatic pass that incorporates the human's decisions,
                        then the conclusions (re-spec / findings / sign-off).
```

### A. Entry gate (before the lenses)

Resolve what only the owner can answer — and **nothing the code can answer for you**. Read the target
and the brief first; anything verifiable by exploration is verified, not asked. Then surface the
remaining high-impact decisions as a **single multi-select batch**:

- Each question carries 2–4 candidate answers, **your recommended one first and marked "(recommended)"**.
- The host's free-text / "other" option lets the owner add an answer you didn't list.
- Ask only what changes the grill's direction. A handful of questions, one batch — not an interrogation.

If the host has no interactive prompt, state your assumed answers explicitly and proceed.

### C. User gate (after the three passes, before conclusions)

The three lenses surface doubts, contradictions, and unverified assumptions. **Do not resolve them
silently.** For each open doubt, compute your **recommended answer and the live alternatives**, then
present them all as **one multi-select batch** for the owner to decide:

- Each item: the doubt in plain language + your recommended answer (pre-selected) + the alternatives
  + the lens(es) that raised it.
- The owner can **accept** the recommendation, **pick an alternative**, **add their own** answer, or
  **dispute** it (reject + note).
- Group by severity (blocking → significant → minor) so it is scannable; pre-select the recommended answers.
- Cap each batch at the host's limit. In Claude Code, `AskUserQuestion` allows ≤4 questions, 2–4 options
  each, and auto-adds an "Other" free-text field (= add-your-own / dispute). If more doubts remain, run
  several batches, most decision-critical first, and say how many remain.

This gate is run by the **orchestrating agent, never by a grill subagent** — subagents cannot prompt the
owner. The lenses produce findings + recommended answers; the orchestrator surfaces them and collects
the decisions.

### D. Informed re-grill

Feed the owner's decisions back in and run **one more automatic pass**, focused on:

- The seams the chosen answers create.
- Anything the owner disputed or added that the lenses had not considered.

Then converge to conclusions. Repeat the gate only if the re-grill surfaces genuinely new blocking
doubts — do not loop the human on settled points.

### When to skip the gates

Proportional to **novelty × blast radius** (see *Grill Depth*). A low-novelty, low-blast artifact needs
no human gate — grill, fix, done. Surface the gate when a real human judgement is at stake: a trade-off
with no clearly-right answer, a disputed assumption, a scope boundary only the owner owns.

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
