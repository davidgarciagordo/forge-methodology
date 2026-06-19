# State Capsule Template

A resume capsule for an active workstream. Commit this alongside the work at the end of every phase. Resume by reading it — not by re-deriving from the plan, spec, and version history.

---

```markdown
# State — [Workstream Name]

Updated: [date and time]

## Status
[one of: in-progress / blocked / waiting-for-review / complete]

## Done
- [work unit name] — [brief note on outcome or any deviation from plan]
- [work unit name]
- ...

## In-flight
- [work unit name] — [what specifically is in progress; where it was left off]

## Next
- [work unit name] — [any prerequisite state or context needed to start]
- [work unit name]
- ...

## Blocked on
- [blocker description] — [what is needed to unblock; who needs to act]

## Decisions made
- [decision] — [brief rationale; include any alternatives that were rejected]
- ...

## Deferred / out of scope
- [item] — [why it was deferred; when it should be revisited]
```

---

## How to use this

1. Create a `state.md` file in the workstream's working directory at the start of the session.
2. Update it at the end of every phase before checkpointing.
3. When a session ends (due to quota, time, or interruption), the state capsule is the last commit.
4. When resuming, read the state capsule first. It tells you exactly where to start.

---

## Example

```markdown
# State — auth-workstream

Updated: 2026-06-19 14:30

## Status
in-progress

## Done
- auth-middleware-refactor — complete; typecheck green; all tests pass; token-refresh integration test added
- auth-session-cleanup — complete; expired sessions now purged on login

## In-flight
- auth-audit-logging — added event schema; write to log store not yet wired up; stopped at line 87 of audit-logger.ts

## Next
- auth-rate-limiting — depends on auth-audit-logging completing first (needs the event emitter)
- auth-docs-update — independent; can run in parallel with rate-limiting

## Blocked on
- None

## Decisions made
- Token expiry: chose 15m access + 7d refresh (vs. 1h access) — aligns with security team guidance from 2026-05-review
- Audit log format: JSON Lines over structured DB table — easier to ship to external SIEM without schema migration

## Deferred / out of scope
- MFA enforcement — out of scope for this phase; tracked in backlog as auth-mfa-phase2
```
