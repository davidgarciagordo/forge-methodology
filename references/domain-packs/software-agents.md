# Forge — Software Agents Pack

> Domain pack for Forge methodology. Covers multi-agent and multi-worker orchestration for software work.
> Core references: [execution-modes.md](../execution-modes.md) · [planning.md](../planning.md) · [verification.md](../verification.md)

---

## Grill Lenses for Multi-Agent Plans

| Lens | Perspective | Focus |
|------|------------|-------|
| **Orchestration Architect** | System view | File ownership graph: does every parallel stream have disjoint ownership? Are cross-cutting files (lock files, shared config, i18n bundles) assigned to a single integrator? Is the serialization order derived from real dependencies, not assumed? |
| **Failure Analyst** | Human reality | What happens when a worker crashes, hits a quota limit, or hangs mid-phase? Can the workstream be resumed without starting over? Is there a reserve to inherit the work? |
| **Execution Realist** | Technical depth | How are workers launched, monitored, and confirmed dead? Is liveness verified by PID and prompt (not naive process count)? Is the kill sequence safe (parent + agent + all subprocesses)? |

---

## Hard Rules for Multi-Worker Orchestration

These rules are not guidelines — violating them causes race conditions, lost work, or false "all green" reports.

**Worker isolation:**
- **1 worktree = 1 worker = 1 branch.** No exceptions. Two workers in the same worktree = two writers racing on shared files.
- Verify a worker is truly dead by **PID and actual prompt output**, not by `grep | wc` or process count. A false negative from a naive grep has launched a second worker into an occupied worktree.
- When killing a worker, kill the **whole process tree**: parent shell + agent process + any spawned subprocesses (build tools, watchers, stream processors). Killing only the top-level process leaves orphaned children writing to the worktree.

**Launch parameters:**
- Launch workers headless with `--permission-mode acceptEdits` plus an explicit allowlist of permitted tools (version control, package manager, runtime). Anything not on the allowlist requires human approval.
- **Never use `--dangerously-skip-permissions`.** If a worker needs permissions beyond the allowlist, expand the allowlist explicitly — do not bypass the permission system.
- **Zero billable infrastructure resources** (cloud services, external APIs, paid subscriptions) without explicit human approval before creation.

**Work persistence:**
- Commit work at the end of every phase — not just at the end of the entire task. A session limit, quota hit, or crash between phase commits = that phase is lost.
- Each workstream maintains a committed **resume capsule** (`state.md` or equivalent): what is done, what is in-flight, what is next, and key decisions made. Resume by reading it, not by re-deriving from the plan + spec + version history.
- Sub-phase WIP commits for tasks longer than ~1 hour. If the work is losable, it should be committed.

**Quota scheduling:**
- Build a capacity ledger before launching parallel workers: which tier does each stream need, and what capacity is available?
- Route the heaviest / most critical workstreams to the highest available capacity.
- Checkpoint and migrate preventively at ~80% of a session window, not reactively when the limit is hit.
- Keep one worker slot in reserve to inherit a failing workstream. Resume in the **same worktree**, from the last checkpoint — never from scratch.

---

## Definition of Done — Multi-Agent Execution

A multi-agent execution is done when:

- [ ] All workers have exited cleanly (confirmed by PID, not assumed)
- [ ] All phase commits are in the version history
- [ ] Full independent verify has run (typecheck + full test suite + domain reviewers if applicable) — not just each worker's own test area
- [ ] No worker's self-reported "green" is accepted without independent confirmation
- [ ] Resume capsule updated to reflect final state

---

## What to Verify

### Worker state
- Confirm every launched worker is either complete or explicitly terminated before declaring execution done
- Do not trust a worker's self-report of "done" or "green" without an independent check

### Output correctness
- Run **typecheck + full test suite** as a single independent job after all workers complete — not as the sum of each worker's partial results
- Workers running only their assigned test area can produce a false "all green": the integration surface between areas is not tested by either worker

### Ownership integrity
- Verify that no two workers wrote to the same file during parallel execution (check version history for concurrent edits to the same path)
- If a conflict occurred, treat it as a plan defect: the ownership graph was wrong, and the plan must be corrected before re-running

---

## Failure modes these rules prevent

- **False-negative liveness check → duplicate-worker race.** A grep-based process count returned 0 for a live worker; a second worker was launched into the same worktree and both wrote to the same files. Verify liveness by PID + actual prompt output, never by counting grep matches.
- **Worker self-reports "250 tests passing" → critical failures in independent verify.** The worker's own area was green; the independent full typecheck + full suite found an integration-surface typecheck error and 6 failures in modules the worker never ran. "Green" must always mean typecheck + full suite, verified independently.
