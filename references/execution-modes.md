# Execution Modes — How to Work Optimally

Once the plan is locked, execution is about choosing the right working mode for each part of the work.

---

## The Four Execution Principles

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
