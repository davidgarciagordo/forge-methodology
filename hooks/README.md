# Forge enforcement hooks

These hooks turn Forge's completeness rule from **advisory** ("you should verify against the reference")
into **machine-checked** ("you cannot open a PR while the matrix is incomplete").

## `check-acceptance-matrix.sh`

A `PreToolUse` hook on `Bash`. When Claude Code is about to run a **"declare done"** command
(`gh pr create`, or any command containing `forge-done` / `FORGE_DONE`), the hook:

1. Finds the Acceptance Matrix (see discovery order below).
2. Parses every `in-scope = yes` row.
3. **Blocks** (exit code 2) if any in-scope row is not `built = yes` **and** has non-empty `evidence`
   **and** has a `verified-by` that is non-empty and not the executor.

`GREEN` (tests pass on what exists) is not enough. The hook enforces `COMPLETE` (every in-scope
requirement of the reference traced to evidence and independently verified).

### Matrix discovery order

1. `$FORGE_ACCEPTANCE_MATRIX` — explicit path to the spec file.
2. `.forge/spec.md` at the repo root.
3. Any tracked `*.md` containing a `## Acceptance Matrix` heading.

Files that still carry the `<!-- forge:template -->` marker (the pristine `spec-and-dod.md` template) are
**skipped** by the scan, so the blank template is never mistaken for an incomplete live matrix. Delete that
marker when you turn a copy into your real spec.

If no matrix is found the hook **does not block** (the repo may not use Forge) and prints a notice.
Set `FORGE_REQUIRE_MATRIX=1` to make a missing/empty matrix itself a blocking condition.

### Cell semantics

- A row is **gated** only when `in-scope?` is `yes`/`true`/`✓`.
- `built?` must be `yes`/`true`/`✓`/`done`.
- `evidence` and `verified-by` are "empty" when blank or one of: `—`, `-`, `TODO`, `WIP`, `pending`,
  `TBD`, `n/a`.
- `verified-by` literally equal to `executor`/`self`/`same` (a placeholder) fails the independence check.

## Install

### As part of the Forge plugin (recommended)

Installing the `forge-methodology` Claude Code plugin registers `hooks/hooks.json` automatically;
`${CLAUDE_PLUGIN_ROOT}` resolves to the plugin directory. Nothing else to do.

### Manually, in a single project

Add to `.claude/settings.json` (project) or `~/.claude/settings.json` (user):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash /ABSOLUTE/PATH/forge-methodology/hooks/check-acceptance-matrix.sh", "timeout": 20 }
        ]
      }
    ]
  }
}
```

Make the script executable: `chmod +x hooks/check-acceptance-matrix.sh`.

### Run it manually (CI or local)

The script reads the tool payload on stdin. To force a check from a script or CI, feed it a synthetic
`gh pr create` command:

```bash
echo '{"tool_input":{"command":"gh pr create"}}' | \
  FORGE_REQUIRE_MATRIX=1 bash hooks/check-acceptance-matrix.sh; echo "exit=$?"
```

Exit `0` = complete (or nothing to enforce), exit `2` = blocked with the offending rows on stderr.

> Dependencies: `bash`, `awk`, `grep`, `git`. `jq` is used when present but not required.
