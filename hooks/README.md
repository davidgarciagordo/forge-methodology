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
3. Any **git-tracked** `*.md` containing a `## Acceptance Matrix` heading (untracked scratch files never
   gate a PR). Outside a git repo, the hook falls back to a filesystem scan from the root, excluding
   `.git`/`node_modules`/`vendor`.

Files that still carry the `<!-- forge:template -->` marker (the pristine `spec-and-dod.md` template) are
**skipped** by the scan, so the blank template is never mistaken for an incomplete live matrix. Delete that
marker when you turn a copy into your real spec.

If no matrix is found the hook **does not block** (the repo may not use Forge) and prints a notice.
Set `FORGE_REQUIRE_MATRIX=1` to make a missing/empty matrix itself a blocking condition.

### Old or multiple specs (escape hatch)

The scan finds **every** live matrix in the repo, so a finished-but-never-completed spec from a past
feature would block every new PR forever. Two escapes, both honest:

- **Point the hook at the active spec**: set `FORGE_ACCEPTANCE_MATRIX=path/to/active-spec.md` (in the hook
  command's environment or your settings `env`) — discovery then stops at that file and ignores the rest.
- **Archive the old spec**: re-add the `<!-- forge:template -->` marker at the top of the stale file — the
  scan skips template-marked files. Do this only for specs that no longer represent claimable work.

The block message prints both escapes when it fires.

### Malformed headers are warned, not silently passed

The parser matches columns **by header name**. A header that lacks `in-scope`, `built`, or `evidence`
would silently un-gate every row under it (each row resolves as out-of-scope). The hook now prints a
`forge: warning: matrix header incomplete …` line to stderr naming the missing column(s), and reports
"no gateable in-scope rows" instead of claiming `COMPLETE`. With `FORGE_REQUIRE_MATRIX=1` a matrix that
gates zero rows is itself blocking.

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
