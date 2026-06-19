# Planning — Global Plan Before Execution

Forge requires a global plan covering ALL work units before execution begins. No gaps. No "we'll figure it out later."

---

## Why a Global Plan?

A partial plan creates the illusion of alignment. Execution starts, then hits an unplanned dependency, improvises, and diverges from the spec. The global plan eliminates mid-flight design decisions by requiring them up front.

> Once the global plan is locked, execution is mechanical.

---

## Work Unit

A **work unit** is the atomic unit of planning — independently ownable, independently verifiable. What counts as a work unit depends on the domain:

| Domain | Work unit examples |
|--------|-------------------|
| Software | A module, a file, an API endpoint, a migration |
| Marketing | A campaign asset, a landing page section, a copy variant |
| Finance | A model tab, a scenario, a report section |
| Design | A component, a screen, a flow section |
| Research | A section, a source review, an analysis chunk |
| Operations | A process step, a runbook section, a handoff |

---

## Plan Structure

Each work unit in the plan declares:

```
Work Unit: [name]
  Phase:              [which phase or milestone this belongs to]
  Inputs:             [what this unit depends on — outputs of other work units]
  Outputs:            [what this unit produces]
  Owner:              [which agent, person, or capability tier executes this]
  Parallelizable:     yes / no
  Serial-after:       [list of work units that must complete first]
  Acceptance criteria:[how we know this unit is done — specific, checkable]
```

---

## The Dependency Graph

From the declared inputs and outputs, derive the dependency graph:

- Work units with no shared outputs and no dependencies on each other → **parallelizable**: run simultaneously.
- Work unit B depends on A's output → **A must complete before B starts**: run serially.
- **Cross-cutting work units** (their outputs are inputs to many others) → identify them early; assign to a single owner or serialize their touches. Two workers writing to the same artifact = a race condition. Prevent it at plan time.

"Disjoint areas" is a **calculated constraint**, not a wish.

---

## Phase Granularity

Each phase should be:

- **Completable in a bounded session** — roughly 1–2 hours of focused work
- **Independently verifiable** — you can confirm a phase is done without waiting for later phases
- **Losable without pain** — if a session ends mid-phase, the previous phase checkpoint is intact

Mark each phase in the plan as parallelizable or serial (derived from the dependency graph). This is not an aesthetic choice — it is a constraint from the data.

---

## The Planning Checklist

Before locking the plan:

- [ ] All work units are listed — no "we'll add that later"
- [ ] Every work unit has declared inputs and outputs
- [ ] Every work unit has an assigned owner (person, agent, or capability tier)
- [ ] The dependency graph is computed; cross-cutting units are identified and assigned
- [ ] Parallelizable vs. serial is explicitly marked for every unit
- [ ] Acceptance criteria are defined per phase
- [ ] The plan has been grilled (deep-reasoning tier) for gaps, contradictions, and unplanned dependencies

---

## Resume Capsule

Per active workstream, maintain a lightweight state artifact committed alongside the work:

```
Workstream: [name]
Done:        [list of completed work units]
In-flight:   [work unit currently being executed]
Next:        [list of work units queued]
Decisions:   [key decisions that affect upcoming work]
Blocked on:  [anything waiting for external input]
```

Checkpoint this capsule at the end of each phase. Resume by reading it — not by re-deriving from scratch from the spec and git history.

See the template at [../templates/state-capsule.md](../templates/state-capsule.md).

---

## Work Unit Template

See [../templates/work-unit-plan.md](../templates/work-unit-plan.md) for a ready-to-fill template.
