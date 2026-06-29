# Forge agents — the executable spine

Forge's references are *reasoning a human or agent loads*. These four **agents** are the *executable units*
that make completeness mechanical instead of advisory. They thread one artifact — the **enumerated
reference → Acceptance Matrix** — from research through verify.

| Agent | Runs at | Job | Axiom | Tier |
|-------|---------|-----|-------|------|
| [`reference-decomposer`](reference-decomposer.md) | Step 1.5 (Reference Decomposition) | Named reference → flat enumerated capability list with req-ids → seeds the Acceptance Matrix | "Parity with X" must enumerate what X does | execution |
| [`completeness-critic`](completeness-critic.md) | Step 3 (grill, on the spec) **and** Step 6 (verify) | The 4th grill lens: hunts **absences** vs. the reference | A reference capability absent from the spec/plan = **blocking** finding | deep-reasoning |
| [`independent-verifier`](independent-verifier.md) | Step 6 (Verify) | Audits the matrix row-by-row; demands evidence; enforces verifier ≠ executor | GREEN ≠ COMPLETE; self-verified-green doesn't count | deep-reasoning |
| [`visual-fidelity-checker`](visual-fidelity-checker.md) | Step 5–6 (per UI unit) | Side-by-side of each UI surface vs. the reference's screen | External fidelity ≠ internal theme parity | execution |

## How they chain

```
reference-decomposer  ──► enumerated reference (R1..Rn) ──► Acceptance Matrix (spec §2/§3)
        │
        ▼
completeness-critic (early)  ──► every Rn has a matrix row + a work-unit owner?  blocking if not
        │
   …execution… (visual-fidelity-checker per UI surface produces evidence for UI rows)
        │
        ▼
completeness-critic (late) + independent-verifier  ──► every in-scope Rn built + evidenced + verified≠executor
        │
        ▼
hooks/check-acceptance-matrix.sh  ──► blocks "declare done"/PR if the matrix isn't 100% traced
```

The first three are model-routed: the two critics run on the **deep-reasoning tier** (they decide what's
missing and whether evidence holds), the decomposer and visual checker on the **execution tier**.

These ship in the plugin's `agents/` directory and load automatically in Claude Code. In any other host,
read each file's body as the role's system prompt — they are vendor-neutral.
