**English** | [Español](README.es.md)

# Forge — Usage Examples

> Copy-paste prompts showing how to invoke Forge across different task types and domains.

These are real prompts — paste one into your AI assistant to start a Forge session. Each example shows what Forge produces, which grill lenses apply, and what "done" looks like for that domain.

---

## Prompt Styles

Forge works with both short and structured prompts:

**Short** — minimal context, let Forge drive the alignment step:

```
Run this through the Forge: add idempotent payment webhooks to our checkout service.
```

**Structured** — provide context, constraints, and definition of done upfront:

```
Run this through the Forge.

Task: add idempotent payment webhooks to our checkout service
Context: Node.js/Express API, PostgreSQL, Stripe events
Constraints: zero-downtime deploy; existing Stripe retry logic must not cause duplicate charges
Definition of done: webhook endpoint handles retries idempotently, all Stripe event types
we use are covered, integration tests pass, security checklist cleared
```

Both work. The structured form compresses the alignment step because you have already answered the value question. The short form lets Forge surface the alignment questions first.

---

## 1. Backend Feature — Idempotent Payment Webhooks

**Domain pack:** [software-backend](../references/domain-packs/software-backend.md)

### Short prompt

```
Run this through the Forge: add idempotent payment webhooks to our checkout service.
```

### Structured prompt

```
Run this through the Forge.

Task: add idempotent payment webhooks to our checkout service
Context: Node.js/Express API, PostgreSQL, Stripe; ~500 webhook events/day; existing
handler has no idempotency key check
Constraints: zero-downtime deploy; Stripe retries failed events up to 3×; must not
produce duplicate charges or inventory decrements
Definition of done: idempotency key stored and checked on every event, handler is safe
to retry, all Stripe event types we use are covered, integration tests pass, security
checklist cleared, no N+1 queries introduced
```

### What Forge does with it

- **Spec produced:** versioned document defining the idempotency key schema, storage strategy (dedicated table or cache layer), event types in scope, error handling for duplicate vs. genuine replay, and the API contract for the webhook endpoint.
- **Grill — Platform Architect lens:** reads the existing handler code, checks whether a transaction wrapper already exists in the codebase, identifies bounded contexts affected (orders, inventory, billing), and flags any missing index on the idempotency key column.
- **Grill — Real Operator lens:** stress-tests the spec against Stripe retrying after a partial commit, a network timeout mid-handler, and an operator manually replaying an event to resolve a support issue — the cases that never appear in the happy path.
- **Grill — Domain Engineer lens:** checks for race conditions when two Stripe retries arrive within milliseconds of each other, verifies transaction isolation level, and flags whether the idempotency check and the business action are inside the same transaction boundary.
- **Definition of done:** typecheck green, full suite green (not just the webhook module), integration tests cover retry scenarios, security checklist cleared, no regressions against baseline.

---

## 2. Frontend / UI — Onboarding Flow Redesign

**Domain pack:** [software-frontend](../references/domain-packs/software-frontend.md)

### Prompt

```
Run this through the Forge.

Task: redesign the onboarding flow for new users
Context: React app, Tailwind CSS with our custom design token layer; current flow has
~65% drop-off at step 3 of 5; mobile traffic is 70% of our user base
Constraints: must use existing design tokens; no new dependencies; flow must work on
slow 3G connections
Definition of done: drop-off measurably reduced; flow verified on mobile at all
breakpoints; light/dark mode correct; keyboard navigation and screen reader output pass
accessibility audit; component stories created for every new component
```

### What Forge does with it

- **Spec produced:** a decision brief that pins down which step is the actual drop-off source (from analytics, not assumed), what the redesigned flow covers per step, which components are reused vs. new, and what "reduced drop-off" means in measurable, verifiable terms before any pixel is moved.
- **Grill — UX/User lens:** challenges whether step 3 is the cause or a symptom, requests the analytics breakdowns by device, locale, and referral, and tests the spec against the case of a user who returns mid-onboarding on a different device.
- **Grill — Accessibility lens:** flags any step that relies on hover states only, checks focus management when the user advances between steps, and verifies that the progress indicator is announced correctly to screen readers.
- **Grill — Design System lens:** checks whether the redesign uses existing tokens and components or silently introduces hardcoded values, and flags any surface where the new flow breaks in dark mode or at the smallest defined breakpoint.
- **Definition of done:** visual gate passed (screenshots for every step in light/dark × mobile/tablet/desktop), accessibility audit passed, component stories merged, drop-off metric measurable before and after — not declared reduced without data.

---

## 3. Security Audit — Auth and Session Handling

**Domain pack:** [security](../references/domain-packs/security.md)

### Prompt

```
Run this through the Forge.

Task: audit our authentication and session handling end to end
Context: JWT-based auth, refresh tokens stored in httpOnly cookies, Node.js/Express
backend, PostgreSQL; approaching a SOC 2 Type II audit
Constraints: must cover both code and infrastructure config; findings must be
actionable and severity-rated
Definition of done: OWASP Top 10 items all checked, every blocking finding has a
remediation plan with an owner and a date, SOC 2 auth controls checklist completed,
incident response runbook updated
```

### What Forge does with it

- **Spec produced:** a threat model scoped to the auth surface — entry points, trust boundaries, token lifecycle (issuance, refresh, rotation, revocation), session invalidation paths, and the SOC 2 controls that map to each component.
- **Grill — Attacker lens:** attempts to exploit the auth surface: JWT algorithm confusion attacks, refresh token replay after logout, session fixation, privilege escalation via claim manipulation, and abuse of the "forgot password" flow as an account enumeration side-channel.
- **Grill — Defender/Incident Responder lens:** asks what alerts fire when a token is stolen and replayed, what the blast radius is if the signing key is leaked, how quickly sessions can be invalidated across all active devices, and whether the audit log captures enough to reconstruct a full incident timeline.
- **Grill — Compliance/Audit lens:** maps each control to the SOC 2 CC6 (logical access) control family, checks for required evidence (access logs, provisioning records, revocation procedures), and flags what auditors will ask for that is not yet documented or automated.
- **Definition of done:** all findings severity-rated and assigned to owners, OWASP Top 10 fully addressed, SOC 2 evidence pack assembled, incident response runbook updated, no secrets present in version history.

---

## 4. Product Decision — Mobile App vs. PWA

**Domain pack:** [brainstorming](../references/domain-packs/brainstorming.md)

### Prompt

```
Run this through the Forge.

Task: decide whether to build a native mobile app or a PWA for our next product phase
Context: B2B SaaS, ~2,000 users, 60% access via mobile to check dashboards and
notifications; engineering team of 4 with React expertise and no native mobile
experience; 6-month runway to next funding round
Constraints: team capacity is fixed; cannot hire native developers in this cycle;
decision must be made this week to unblock roadmap planning
Definition of done: a written decision brief with the chosen path, explicit assumptions,
evaluation criteria used, and the strongest counter-argument to the chosen option
documented and addressed
```

### What Forge does with it

- **Spec produced:** a decision brief containing the decision frame (what we are choosing and why it matters now), evaluation criteria ranked by importance (user experience quality, delivery speed, team capability, cost, offline capability, app store dependencies), options with explicit assumptions per option, and the constraints that rule options in or out.
- **Grill — Critic lens:** challenges the assumption that 60% mobile usage means users need native features, asks whether "checking dashboards" actually requires anything beyond a well-optimized responsive web app, and probes whether the 6-month constraint is a real deadline or a soft preference.
- **Grill — Alternative View lens:** argues the strongest case for the option not chosen, surfaces the "build nothing new and optimize the existing web app" option that was likely not generated, and asks what teams that chose the other path actually learned.
- **Grill — Feasibility lens:** models what shipping native would actually require — App Store and Play Store submission timelines, review cycles, certificate management, push notification setup, deep-link handling — and compares each to the PWA equivalent. Flags the hidden costs that do not appear in the initial estimate.
- **Definition of done:** written decision brief committed to the repo, chosen option documented with all key assumptions marked verified or unverified, strongest counter-argument acknowledged, next steps are specific and owned — not "we will explore option A."

---

## 5. Marketing — Product Launch Campaign

**Domain pack:** [marketing](../references/domain-packs/marketing.md)

### Prompt

```
Run this through the Forge.

Task: plan the launch campaign for our new invoicing automation product
Context: B2B SaaS targeting finance teams at mid-market companies (50–500 employees);
product reduces invoice processing time by ~70%; launch in 6 weeks; budget is $15k
Constraints: no paid social; primary channels are email, LinkedIn organic, and a
launch on Product Hunt; we have 3 customer case studies available
Definition of done: campaign brief with messaging, channel plan, asset list, success
metrics defined before launch (not after), legal/compliance review completed
```

### What Forge does with it

- **Spec produced:** a campaign brief with the primary message, per-channel plan, asset requirements, timeline, and success metrics defined upfront — not post-hoc. Includes key assumptions about the target audience's current behavior and primary pain, stated explicitly so they can be verified.
- **Grill — Customer/Audience lens:** tests whether "reduces processing time by 70%" is the message that finance teams at mid-market companies actually respond to, or whether the real pain is error rates, audit risk, or month-end pressure — and asks which of the three case studies maps to the audience's primary concern.
- **Grill — Skeptic lens:** asks why a finance team would switch from their current process, what the incumbent solution does well that this product does not, and whether the Product Hunt audience is the actual buyer or a tech-adjacent crowd that will not convert.
- **Grill — Brand/Legal lens:** checks whether the "70% reduction" claim is verified and defensible using the case study data, flags required disclosures (advertising standards, any financial claims), and verifies that LinkedIn and email copy fit the established brand voice.
- **Definition of done:** all claims substantiated with evidence, audience validation completed (minimum: one customer interview), metrics defined and measurable before launch, legal review done, all assets formatted correctly per channel specs.

---

## 6. Finance — 3-Year Revenue and Cash-Flow Model

**Domain pack:** [finance](../references/domain-packs/finance.md)

### Prompt

```
Run this through the Forge.

Task: build a 3-year revenue and cash-flow model for our SaaS business to support a
Series A fundraise
Context: B2B SaaS, monthly subscriptions, current ARR $480k, 3 pricing tiers; monthly
churn is ~2%; fundraise target is $3M; investors will stress-test the model
Constraints: must include base, downside, and upside scenarios; all assumptions must
be documented with sources; format must be investor-ready
Definition of done: model reconciles to current actuals, sensitivity analysis covers
key inputs (churn rate, new logo growth, expansion revenue), independent review by our
CFO-advisor completed, no hardcoded values in formulas
```

### What Forge does with it

- **Spec produced:** a model brief defining the output format (monthly/quarterly/annual), the key metrics to model (MRR waterfall: new, expansion, contraction, churn), the input assumptions to parameterize, and the scenarios to test — before building begins.
- **Grill — Auditor lens:** checks whether the model ties to the current actuals, verifies the churn rate (2% monthly = ~22% annually) against actual cohort data rather than a stated number, and flags any assumption that is a round number without a documented source.
- **Grill — Risk Analyst lens:** stress-tests the downside scenario: what if churn doubles, new logo growth halves, and the fundraise takes 6 months longer than planned? Models the cash-out date under the downside case and flags whether $3M is sufficient given that risk.
- **Grill — Stakeholder/Decision-maker lens:** asks whether the model answers the specific question investors will ask ("when do you reach cash-flow positive?"), checks whether expansion revenue assumptions are supported by existing customer behavior data, and verifies that the output format supports a decision rather than just displaying numbers.
- **Definition of done:** model reconciles to current actuals, sensitivity analysis complete across three scenarios, all inputs documented with source and date, CFO-advisor independent review passed, no hardcoded values, all scenarios clearly labeled.

---

## 7. Data Migration — MySQL to PostgreSQL, Zero Downtime

**Domain packs:** [software-backend](../references/domain-packs/software-backend.md) · [software-agents](../references/domain-packs/software-agents.md)

### Prompt

```
Run this through the Forge.

Task: migrate our production database from MySQL to PostgreSQL with zero downtime
Context: 15 tables, ~8M rows, 3 services read/write this database; running on AWS;
MySQL 5.7; peak traffic is 08:00–22:00 UTC; low-traffic window is 02:00–06:00 UTC
Constraints: zero data loss; application must remain available during migration;
rollback must be possible within 15 minutes of any failure; dual-write complexity
must be contained to under 2 hours
Definition of done: data parity verified on a representative sample, all 3 services
tested against Postgres in staging, cutover completed in the low-traffic window,
rollback procedure tested before cutover night, zero errors in the 24h post-cutover
monitoring window
```

### What Forge does with it

- **Spec produced:** a migration spec defining the dual-write strategy, the cutover sequence (with exact steps and an owner per step), rollback trigger conditions and decision points, the data parity verification method (row count + checksum), and the go/no-go criteria for each phase.
- **Grill — Platform Architect lens:** reads the existing schema and flags PostgreSQL incompatibilities (MySQL-specific types, `AUTO_INCREMENT` vs. sequences, `TINYINT(1)` for booleans, JSON handling differences), scans all 3 services for raw SQL strings that will fail on Postgres, and identifies services using MySQL-specific functions.
- **Grill — Real Operator lens:** stress-tests the cutover sequence against the scenario where one of the 3 services cannot be redeployed within the maintenance window, asks what happens to writes that arrive during the DNS cutover window, and tests the rollback procedure against a case where the two databases have already diverged.
- **Grill — Domain Engineer lens:** checks for transaction isolation differences between MySQL and Postgres that could affect application behavior, flags application-level locking that assumes MySQL's locking semantics, and verifies that the dual-write window handles conflicts when both databases receive competing writes.
- **Execution:** parallel workers with disjoint file ownership — schema translation, service compatibility patches, parity verification scripts, staging validation — each in its own isolated branch. Workers commit at the end of each phase; a failure at any phase resumes from the last checkpoint rather than from scratch.
- **Definition of done:** row-count and checksum parity verified, all 3 services tested against Postgres in staging, rollback procedure tested before cutover night, 24h post-cutover monitoring window passed with zero errors.

---

## 8. Research and Analysis — Vendor Evaluation

**Domain reference:** [the-loop.md](../references/the-loop.md) (generic loop — no dedicated pack needed)

### Prompt

```
Run this through the Forge.

Task: evaluate three search infrastructure vendors and recommend one
Context: replacing our self-managed Elasticsearch cluster; candidates are Algolia,
Typesense, and an upgraded self-managed OpenSearch cluster; index has ~12M documents,
peak query volume is ~800 req/s; team has no Elasticsearch ops expertise
Constraints: decision within 2 weeks; migration completable in one quarter; cost
ceiling is $3k/month
Definition of done: written evaluation with scoring against defined criteria, all key
assumptions verified (not asserted), strongest counter-argument to the recommended
option documented, decision specific enough to act on immediately
```

### What Forge does with it

- **Spec produced:** a research brief that pins down the evaluation criteria (query latency at scale, indexing throughput, operational burden, cost, migration complexity, vendor lock-in risk), their relative weights, and the verification method for each — before any vendor is researched.
- **Grill — Methodology lens:** checks whether the criteria are measurable and verifiable, asks whether the 800 req/s figure is peak or sustained average, and challenges whether "no ops expertise" is a constraint that applies to all three options or only to the self-managed one.
- **Grill — Domain Expert lens:** asks what the current Elasticsearch performance baseline actually is (not just "it is slow"), whether the 12M document index has the query patterns (faceting, geo, typo-tolerance) that materially differentiate the vendors, and what migration experience data from teams that made this switch is publicly available.
- **Grill — Reproducibility lens:** checks that vendor recommendations are independently verifiable (pricing is public, benchmarks are reproducible, migration guides exist), flags any claim that rests only on vendor-provided benchmarks, and verifies that the cost estimate accounts for indexing operations and data transfer — not just query volume.
- **Definition of done:** written evaluation committed to the repo, all key assumptions marked verified with a cited source, recommendation is specific (names the vendor, states the migration approach, identifies the first three actions), strongest counter-argument acknowledged and addressed.

---

## Summary

| # | Task | Domain pack |
|---|------|-------------|
| 1 | Idempotent payment webhooks | [software-backend](../references/domain-packs/software-backend.md) |
| 2 | Onboarding flow redesign | [software-frontend](../references/domain-packs/software-frontend.md) |
| 3 | Auth and session security audit | [security](../references/domain-packs/security.md) |
| 4 | Mobile app vs. PWA decision | [brainstorming](../references/domain-packs/brainstorming.md) |
| 5 | Product launch campaign | [marketing](../references/domain-packs/marketing.md) |
| 6 | 3-year revenue and cash-flow model | [finance](../references/domain-packs/finance.md) |
| 7 | MySQL → PostgreSQL zero-downtime migration | [software-backend](../references/domain-packs/software-backend.md) · [software-agents](../references/domain-packs/software-agents.md) |
| 8 | Vendor evaluation and recommendation | [the-loop](../references/the-loop.md) |

→ Back to [Forge Methodology](../README.md)
