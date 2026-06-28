---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Runs three automatic grill passes, then surfaces the emergent questions as one batch for you to decide (recommended answer + alternatives + add-your-own + dispute), then one informed pass. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

**If a question can be answered by exploring the codebase, explore the codebase instead — never ask me what you can verify yourself.**

Run it in four moves:

**A. Entry gate.** Read the plan and the code first. Then ask the highest-impact open questions as ONE batch — each with 2–4 candidate answers, your recommended one first and marked "(recommended)", plus room for me to add my own. Ask only what changes the direction; skip anything the code already answers.

**B. Three automatic passes.** Grill hard through three rounds without stopping for me — each round attacking from a different angle: the **system/rules view**, the **real-use view**, the **technical-depth view**. Collect the doubts, contradictions, and unverified assumptions that surface. For each, compute your recommended answer and the live alternatives. An unverified assumption is itself a finding.

**C. User gate.** Now stop and present everything that surfaced as ONE multi-select batch: each item is the doubt in plain language + your recommended answer (pre-selected) + the alternatives + which pass raised it. I can **accept** your recommendation, **pick an alternative**, **add my own** answer, or **dispute** it. Group by severity (blocking → significant → minor) so it's scannable. In Claude Code use `AskUserQuestion` with `multiSelect: true` (≤4 questions per call, 2–4 options each; its "Other" field is my add-your-own / dispute) — loop in further batches if more than four doubts remain, most critical first, and say how many are left. If there's no interactive prompt, list them numbered and ask me to reply.

**D. Informed pass.** Take my decisions, run one more pass focused on the seams they create and anything I disputed or added, then give me the conclusions.

Keep the single-question, one-at-a-time style for anything that genuinely needs back-and-forth — the batched gate is for converging the many small decisions at once, not for replacing real dialogue.
