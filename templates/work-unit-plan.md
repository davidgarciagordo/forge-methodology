# Work Unit Plan Template

Use one block per work unit in the global plan. Copy and fill.

---

```
Work Unit: [descriptive name — what does this unit produce?]

  Phase:              [Phase 1 / Phase 2 / etc.]
  Inputs:             [list of work units whose outputs this depends on; "none" if this is a starting unit]
  Outputs:            [what artifact, result, or deliverable this unit produces]
  Owner:              [person name / role / agent / capability tier that executes this]
  Parallelizable:     yes / no
  Serial-after:       [list of work units that must complete before this one starts; "none" if independent]
  Acceptance criteria:[specific, checkable statement of what done looks like for this unit]
  Estimated effort:   [rough size: small (<1h) / medium (1–4h) / large (4h+)]
```

---

## Example — Software

```
Work Unit: auth-middleware-refactor

  Phase:              Phase 1 — Core auth
  Inputs:             none (this is a starting unit)
  Outputs:            Refactored auth middleware module; updated integration tests
  Owner:              Execution-tier agent (stream: auth)
  Parallelizable:     yes (parallel with ui-login-screen, no shared files)
  Serial-after:       none
  Acceptance criteria:typecheck green; all existing auth tests pass; integration test for new
                      token-refresh flow passes; no hardcoded secrets
  Estimated effort:   medium (2–3h)
```

---

## Example — Marketing

```
Work Unit: homepage-headline-copy

  Phase:              Phase 1 — Messaging
  Inputs:             audience-research-brief (Phase 0 output)
  Outputs:            3 headline variants with rationale; evaluation criteria scoring
  Owner:              Copywriter
  Parallelizable:     yes (parallel with visual-concept, no shared outputs)
  Serial-after:       audience-research-brief
  Acceptance criteria:3 distinct headline options documented; each addresses primary audience
                      objection identified in research; legal review checklist completed
  Estimated effort:   small (2h)
```

---

## Notes

- **Inputs** should reference other work unit names exactly, so the dependency graph can be derived mechanically.
- **Acceptance criteria** must be specific enough that a third party can verify them without asking for clarification.
- **Owner** should specify the capability tier (deep-reasoning / execution / fast) when the owner is an AI agent, so model routing decisions are made at plan time, not ad-hoc.
