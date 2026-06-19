# Model Routing — Capability Tiers

Forge routes work to capability tiers based on the nature of the work, not habit. Using a more powerful tier than the work requires wastes cost and capacity. Using a weaker tier than the work requires produces worse results.

---

## The Three Tiers

| Tier | Use for |
|------|---------|
| **Deep-reasoning tier** | Architecture decisions, adversarial grill, arbitration, critical review, resolving ambiguity — anything where getting it wrong is expensive |
| **Execution tier** | Executing a closed plan or spec, large-scale transformations, high-volume work, refactors, migrations |
| **Fast tier** | Mechanical / trivial work: one-liners, formatting, stubs, status updates, commit tracking, routine coordination |

> **The routing rule:** Use the cheapest tier that handles the task well. Only escalate when the task genuinely requires deeper reasoning.

---

## Routing Heuristic

Ask: *"If I used a weaker tier here, would the output be materially worse?"*

- **Yes** → escalate to the appropriate tier
- **No** → use the faster / cheaper tier

The orchestrator itself follows the same rule. Routine coordination is fast-tier work. Deciding how to rebalance a failing workstream or arbitrate a design conflict is deep-reasoning work.

---

## Example Mapping

*This section maps the tiers to specific models by provider. The methodology is vendor-neutral — use the equivalent tier from whichever provider or tooling you use.*

| Provider | Deep-reasoning | Execution | Fast |
|----------|---------------|-----------|------|
| Anthropic Claude | Opus | Sonnet | Haiku |
| Map to your provider's equivalent (OpenAI, Google, open-source, etc.) | — | — | — |

> When a stronger reasoning model becomes available at your provider, use it for the deep-reasoning tier. The tier is what matters; the specific model is an implementation detail that changes over time.

---

## Common Routing Mistakes

| Mistake | Why it is wrong |
|---------|----------------|
| Deep-reasoning for all tasks by default | Wastes cost; fast and execution tiers handle most tasks equally well |
| Fast tier for architectural decisions or grill | Produces shallower analysis; misses the findings that matter |
| Execution tier for all orchestration | Routine coordination doesn't need it; fast tier or scripts suffice |
| Not applying tier routing to the orchestrator itself | The orchestrator is also work — it follows the same rules |

---

## Grill Depth and Tier

The grill (Step 3) always uses the deep-reasoning tier for the initial pass. Subsequent re-grills can start in the execution tier and escalate only disputed or architectural findings to the deep-reasoning tier — this cuts the biggest reasoning cost without losing rigor on the seams that matter.
