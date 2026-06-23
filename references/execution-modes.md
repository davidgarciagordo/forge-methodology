# Execution Modes — How to Work Optimally

Once the plan is locked, execution is about choosing the right working mode for each part of the work.

---

## The Five Execution Principles

### 1. Parallelize Disjoint Work

Work units with no shared outputs and no mutual dependencies run simultaneously.

Before parallelizing, verify the units are truly disjoint: no shared artifacts both write to, no hidden dependency through a third unit. A race condition happens when two parallel workers both write to the same artifact. The plan prevents this at design time (see [planning.md](./planning.md)).

### 2. Automate Before Spending Effort

If a task is repetitive, mechanical, or high-volume — **automate it with a tool, script, or program** before spending AI capability or human effort on it.

| Task type | Automate with |
|-----------|---------------|
| Searching / finding / counting | `grep`, `rg`, query tools, search APIs |
| Mass transformation | `sed`, `awk`, `jq`, data transformation pipelines |
| Repetitive generation | Template-based tools, code generators, scripts |
| Data reconciliation | Spreadsheet functions, reconciliation scripts |
| Monitoring / polling | Dedicated monitoring tools, not manual checks |

> AI capability (tokens, human attention) is for design, grill, and decisions — not for tasks a `grep` does in milliseconds.

### 3. Right Capability Per Work Unit

Match the capability tier to the work. See [model-routing.md](./model-routing.md) for full tier definitions.

| Work type | Recommended tier |
|-----------|-----------------|
| Architecture decisions, grill, arbitration, critical review | Deep-reasoning tier |
| Executing a closed plan, refactoring, high-volume work | Execution tier |
| Mechanical tasks, formatting, stubs, one-liners | Fast tier |
| Routine coordination, status updates, tracking | Fast tier or scripted |

The orchestrator (the agent or person coordinating parallel work) follows the same rule. Routine coordination is fast-tier work. Deciding how to rebalance a failing workstream is deep-reasoning work.

### 4. Checkpoint and Persist

Work must survive any session boundary, quota limit, or interruption:

- **Persist work per phase/milestone** — not just at the end of the entire task.
- Keep a **resume capsule** (see [planning.md](./planning.md)) per active workstream, updated at each checkpoint.
- When a limit or interruption hits, the next session resumes from the last checkpoint — it does not restart from the beginning.

### 5. Shared Working Memory — one context pack, not N re-discoveries

Parallel and sequential work units share **one evolving context artifact** so no agent re-derives what another already found. This is what keeps a multi-agent run from burning capacity re-reading the same files.

- **Phase-1 context pack:** the first thing execution produces is a shared map — key locations with `file:line` (or the domain's locator), invariants, decisions, and shared vocabulary. Every downstream unit reads it *before* touching the work.
- **Chain findings forward:** each unit appends its **conclusions and locations** (not its raw work) to the pack, so the next unit/phase starts from them. Findings flow phase N → N+1; nobody re-scans from zero.
- **No re-discovery:** if unit A already mapped a subsystem, unit B reads A's entry instead of re-reading the files. Capability spent re-discovering known facts is waste (principle 2).
- The **resume capsule** (per workstream — "where am I", survives sessions) and the **context pack** (shared across units — "what do we collectively know") are complementary, not the same artifact.

---

## Isolated Workspaces — One Workspace per Parallel Unit

Disjoint ownership prevents *logical* collisions; an isolated workspace prevents *physical* ones. Give each parallel unit its own working surface so two units never fight over the same files.

- **In version control:** one **branch per work unit**, each checked out in its own **worktree** (e.g. `git worktree`, a `jj` workspace, or a separate clone) → units build and test simultaneously without touching each other's tree. **One session = one worktree = one branch.** Convergence happens by merge/PR, never by editing a shared checkout.
- **Generic equivalent (any domain):** a separate sandbox, copy, or environment per unit — a duplicated model tab, a draft doc per section. Parallel writers get separate surfaces; convergence is an explicit, reviewed step.
- **Unavoidable shared file** (lock file, shared index, global config) → assign it to a single integrator, or serialize the touches (cross-cutting units, [planning.md](./planning.md)).
- **Ownership claim:** when several agents/people share a repo, each **declares the unit it owns before starting** (a claim file or tracked assignment) so the ownership graph is visible, not assumed — collisions become impossible by construction, not by carefulness.

---

## Selecting the Next Work Unit

The global plan is a **single list**; execution is *selecting* from it, never improvising new work.

- The dependency graph defines the **ready set**: units whose inputs are all satisfied and whose owner/workspace is free.
- Pick the next unit from the ready set (most-blocking / highest-priority first). Mark it in-flight in the resume capsule; the rest stay queued.
- A unit completes → verify against its acceptance criteria → it unlocks its dependents, which enter the ready set. Repeat until the list is empty.
- Progress stays legible: at any moment you see **done / in-flight / ready / blocked**, and you scale up by selecting more ready units into free workspaces.

---

## Capacity and Quota Scheduling

Treat capacity (AI quota, human attention, compute resources) as a first-class resource — not as an afterthought:

1. **Build a capacity ledger before executing.** Know how much capacity each parallel stream needs, and what is available.
2. **Route the heaviest / most critical workstreams to the highest available capacity.** Don't assign critical work to a resource that will hit its limit halfway through.
3. **Checkpoint preventively at ~80% of capacity**, not reactively when the limit is reached. A mid-phase hit wastes the entire in-progress phase.
4. **Keep one unit of capacity in reserve** to inherit a workstream if another hits its limit. Resume the inherited workstream from its checkpoint — never from scratch.

---

## Serialization Points

When to run serially instead of in parallel:

- **Dependency**: work unit B needs the output of work unit A
- **Shared ownership**: two units write to the same artifact
- **Review gates**: a unit whose output must be reviewed before downstream work begins
- **Integration points**: multiple parallel streams must converge before the next phase starts

Identify all serialization points in the plan before execution begins. Discovering them mid-execution is a sign the plan was incomplete.

---

## When Doubts Arise During Execution

If execution surfaces a genuine design question the plan did not answer:

1. **Stop execution** for the affected work units.
2. Return to Step 3 (Grill) or Step 4 (Plan) to resolve the question.
3. Update the spec and plan.
4. Resume execution with the updated plan.

> Do not improvise design mid-execution. An ad-hoc design decision made under execution pressure is rarely reviewed and often wrong.
