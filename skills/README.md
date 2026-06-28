# Companion grill skills

Two standalone, vendor-neutral grill skills bundled with Forge. They are the **interactive,
conversational** form of Forge's adversarial grill (see [`../references/grill.md`](../references/grill.md))
— use them on their own to stress-test a plan or design without running the full Forge loop.

Both follow the same four-move shape as the canonical grill: **entry gate → three automatic passes →
user gate (recommended answer + alternatives + add-your-own + dispute) → informed pass**.

| Skill | What it adds |
|---|---|
| [`grill-me`](grill-me/SKILL.md) | The bare interview. Relentless, one branch at a time, with the two interactive gates. |
| [`grill-with-docs`](grill-with-docs/SKILL.md) | Same, plus domain awareness: challenges the plan against `CONTEXT.md` / ADRs, surfaces terminology conflicts as gate items, and captures resolved terms inline. |

Install either with your skill manager (e.g. `npx skills add davidgarciagordo/forge-methodology`) or copy
the folder into your skills directory. They are self-contained and work with any AI assistant.
