---
description: Audit the Forge Acceptance Matrix — block done unless every in-scope row is built + evidenced + independently verified.
---

Run the Forge completeness gate against the current work's Acceptance Matrix. This is the manual form of
the enforcement that the `check-acceptance-matrix.sh` hook applies automatically at `gh pr create`.

Steps:

1. Locate the spec / Acceptance Matrix: `$FORGE_ACCEPTANCE_MATRIX`, else `.forge/spec.md`, else any
   tracked `*.md` containing a `## Acceptance Matrix` heading. If none exists, tell the user to create one
   from `templates/spec-and-dod.md` and run `reference-decomposer` first — completeness cannot be judged
   without an enumerated reference.

2. Run the machine check (it parses the matrix and reports incomplete in-scope rows):

   ```bash
   echo '{"tool_input":{"command":"gh pr create"}}' | \
     FORGE_REQUIRE_MATRIX=1 bash "${CLAUDE_PLUGIN_ROOT:-.}/hooks/check-acceptance-matrix.sh"; echo "exit=$?"
   ```

3. If it exits non-zero, delegate to the **`independent-verifier`** agent (owner ≠ executor) to audit each
   in-scope row against its evidence and the reference, and to the **`completeness-critic`** agent to hunt
   any reference capability missing from the matrix entirely.

4. Report per-row: built? · evidence checked? · matches reference? · verified-by independent? — and a final
   `COMPLETE` / `INCOMPLETE` verdict. Never report done while any in-scope row is incomplete.

$ARGUMENTS
