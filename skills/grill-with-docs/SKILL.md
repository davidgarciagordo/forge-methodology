---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

**If a question can be answered by exploring the codebase or the docs, explore them instead — never ask me what you can verify yourself.**

Run it in four moves:

**A. Entry gate.** Read the plan, the code, and the existing docs (`CONTEXT.md`, `docs/adr/`) first. Then ask the highest-impact open questions as ONE batch — each with 2–4 candidate answers, your recommended one first and marked "(recommended)", plus room for me to add my own. Ask only what changes the direction; skip anything the code or docs already answer.

**B. Three automatic passes.** Grill hard through three rounds without stopping for me — each round from a different angle: the **system/rules view**, the **real-use view**, the **technical-depth view**. Throughout, challenge the plan against the existing domain model (see *Domain awareness* below): glossary conflicts, fuzzy terms, and contradictions between what I say and what the code/docs show. Collect the doubts, contradictions, and unverified assumptions that surface, each with your recommended answer and live alternatives. An unverified assumption is itself a finding.

**C. User gate.** Now stop and present everything that surfaced as ONE multi-select batch: each item is the doubt in plain language + your recommended answer (pre-selected) + the alternatives + which pass/lens raised it. **Terminology conflicts and canonical-term proposals go here as items too** (e.g. "your glossary defines 'cancellation' as X but you mean Y — adopt Y? / keep X? / rename?"). I can **accept**, **pick an alternative**, **add my own**, or **dispute**. Group by severity so it's scannable. In Claude Code use `AskUserQuestion` with `multiSelect: true` (≤4 questions per call, 2–4 options each; its "Other" field is my add-your-own / dispute) — loop in further batches if more than four doubts remain, most critical first, and say how many are left. If there's no interactive prompt, list them numbered and ask me to reply.

**D. Informed pass + capture.** Take my decisions, run one more pass focused on the seams they create and anything I disputed or added, then give me the conclusions. As terms resolve, update `CONTEXT.md` inline (and offer ADRs sparingly) per *Domain awareness* — don't batch the doc updates, capture them as they happen.

Keep the single-question, one-at-a-time style for anything that genuinely needs back-and-forth — the batched gate is for converging the many small decisions at once, not for replacing real dialogue.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Don't couple `CONTEXT.md` to implementation details. Only include terms that are meaningful to domain experts.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
