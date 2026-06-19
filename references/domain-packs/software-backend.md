# Forge — Software Backend Pack

> Domain pack for Forge methodology. Instantiates the universal 7-step loop for backend software development.
> Core references: [the-loop.md](../the-loop.md) · [grill.md](../grill.md) · [verification.md](../verification.md) · [planning.md](../planning.md)

---

## Grill Lenses for Backend Software

| Lens | Perspective | Focus |
|------|------------|-------|
| **Platform Architect** | System view | Rules, bounded contexts, data ownership. Verifies precedents against actual code with location references (file:line or equivalent). An unverified assumption about existing behavior is a finding. |
| **Real Operator / API Consumer** | Human reality | Day-to-day usage by callers of this API or service. Error cases, missing fields, contract surprises, support-case patterns that repeat in production. What breaks at the counter, not in the spec. |
| **Domain Engineer** | Technical depth | Concurrency, race conditions, data consistency under concurrent writes, what fails in production under load. Caches that go stale. Transactions that are wider or narrower than they need to be. |

---

## Definition of Done — Backend

Backend work is done when **all** of the following are true:

- [ ] Typecheck passes (no type errors in the changed area or in transitive dependents)
- [ ] Full test suite is green — not just the tests for the changed module
- [ ] Integration tests cover the changed API endpoints / service boundaries
- [ ] API contracts are verified (request/response shapes, error codes, versioning)
- [ ] Data integrity checks pass (no orphaned records, no violated constraints)
- [ ] Security checklist cleared (authentication, authorization, input validation, injection prevention, no hardcoded secrets)
- [ ] No regressions vs. the base/main state (compare against baseline before declaring clean)
- [ ] Domain reviewers passed if the change touches shared state, auth, or data isolation boundaries

---

## What to Verify

### Correctness
- Typecheck + unit tests + integration tests (full suite, not just the changed area)
- API contract tests: does the response shape match the declared contract?
- Error handling: do error responses have the right status codes and shapes?

### Data integrity
- Database constraints are not violated
- Transactions are scoped correctly (not too wide, not too narrow)
- No orphaned records or broken foreign keys after the change

### Security (mandatory before merge)
- No hardcoded secrets or credentials
- All user input validated at system boundaries
- Parameterized queries — no string interpolation into SQL
- Authentication and authorization checked on every endpoint
- Rate limiting present on public endpoints
- Error messages do not leak internal stack traces or sensitive data

### Performance
- No N+1 query patterns introduced
- Indexes exist for the new query patterns
- No blocking operations on the critical path

### Isolation
- If the change touches multi-tenant data: tenant isolation is provably preserved
- If the change touches auth: the security boundary has not shifted

---

## Backend Principles

- **Reuse-first at every layer.** Before writing a new utility, query, or wrapper, check if one exists. Cross-cutting concerns (auth, API fetch layer, logging, error handling, i18n, metrics) live in one central place — never duplicated across modules.
- **DRY at the data model level too.** A concept defined in two places will diverge.
- **Bounded contexts in English.** The code names the domain concept precisely; comments explain the non-obvious invariants.
- **Versioned specs and plans in the repo.** Work survives the session (commit per phase/milestone).
