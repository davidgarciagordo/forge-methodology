#!/usr/bin/env bash
# Forge — Acceptance Matrix enforcement hook.
#
# Turns Forge's completeness rule from advisory into machine-checked: it BLOCKS "declaring done"
# (opening a PR) while the Acceptance Matrix in the spec is not 100% traced for in-scope rows.
#
# A row is "done" only when:   in-scope = yes  AND  built = yes  AND  evidence is non-empty
#                              AND  verified-by is non-empty AND ≠ the executor.
#
# Wired as a PreToolUse hook on Bash. It inspects the command Claude Code is about to run; if that
# command opens a PR / declares done (gh pr create, or a commit/push tagged forge-done), it parses
# the Acceptance Matrix and exits non-zero (blocking) when any in-scope row is incomplete.
#
# Matrix discovery order:
#   1. $FORGE_ACCEPTANCE_MATRIX  (explicit path to a spec/markdown file)
#   2. .forge/spec.md
#   3. any tracked *.md containing a "## Acceptance Matrix" heading (scanned from repo root)
#
# If no matrix is found, the hook does NOT block (the repo may not use Forge) but prints a notice.
# To make a missing matrix itself blocking, set FORGE_REQUIRE_MATRIX=1.
#
# Exit codes (Claude Code hook contract): 0 = allow · 2 = block (stderr shown to the model/user).

set -euo pipefail

# ---- 1. Read the tool call (PreToolUse passes a JSON payload on stdin) -------------------------
payload="$(cat 2>/dev/null || true)"

# Extract the bash command. Prefer jq; fall back to a grep when jq is absent.
extract_command() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$payload" | jq -r '.tool_input.command // .tool_input.cmd // empty' 2>/dev/null || true
  else
    printf '%s' "$payload" | grep -oE '"command"[[:space:]]*:[[:space:]]*"([^"\\]|\\.)*"' \
      | head -n1 | sed -E 's/.*"command"[[:space:]]*:[[:space:]]*"(.*)"$/\1/' || true
  fi
}
cmd="$(extract_command)"

# ---- 2. Only act on "declare done" commands ---------------------------------------------------
# gh pr create  → opening a PR is the canonical "declare done" act.
# Also catch an explicit opt-in marker so teams can gate commits/pushes: a command containing
# FORGE_DONE (e.g. `git commit -m "...[forge-done]"` or `FORGE_DONE=1 ...`).
is_declare_done() {
  printf '%s' "$cmd" | grep -Eiq 'gh[[:space:]]+pr[[:space:]]+create' && return 0
  printf '%s' "$cmd" | grep -Eq 'forge-done|FORGE_DONE' && return 0
  return 1
}

if ! is_declare_done; then
  exit 0   # not a done/PR command — nothing to enforce
fi

# ---- 3. Locate the Acceptance Matrix ----------------------------------------------------------
repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

find_matrix_files() {
  if [ -n "${FORGE_ACCEPTANCE_MATRIX:-}" ] && [ -f "$FORGE_ACCEPTANCE_MATRIX" ]; then
    printf '%s\n' "$FORGE_ACCEPTANCE_MATRIX"; return 0
  fi
  if [ -f "$repo_root/.forge/spec.md" ]; then
    printf '%s\n' "$repo_root/.forge/spec.md"; return 0
  fi
  # Files carrying the `forge:template` marker are blank templates, not live specs — skip them.
  grep -rlE '^##[[:space:]]+Acceptance Matrix' "$repo_root" \
    --include='*.md' \
    --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor 2>/dev/null \
    | while IFS= read -r mf; do
        grep -q 'forge:template' "$mf" 2>/dev/null || printf '%s\n' "$mf"
      done || true
}

matrices=()
while IFS= read -r _line; do
  [ -n "$_line" ] && matrices+=("$_line")
done < <(find_matrix_files)

if [ "${#matrices[@]}" -eq 0 ]; then
  if [ "${FORGE_REQUIRE_MATRIX:-0}" = "1" ]; then
    echo "FORGE BLOCK: no Acceptance Matrix found and FORGE_REQUIRE_MATRIX=1." >&2
    echo "Create a spec from templates/spec-and-dod.md before declaring done." >&2
    exit 2
  fi
  echo "forge: no Acceptance Matrix found — skipping completeness check (set FORGE_REQUIRE_MATRIX=1 to enforce)." >&2
  exit 0
fi

# ---- 4. Parse each matrix and collect violations ----------------------------------------------
# The table header must contain "req-id" and "verified-by". Columns are matched by header name so
# the check is robust to minor reordering. Empty/placeholder cells (—, -, TODO, WIP, pending, n/a,
# blank) count as "not satisfied".
report="$(
  for f in "${matrices[@]}"; do
    awk -v FILE="$f" '
      function trim(s){ gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
      function empty(s){
        s=tolower(trim(s))
        if (s=="" || s=="-" || s=="—" || s=="–" || s=="todo" || s=="wip" || s=="pending" || s=="tbd" || s=="n/a" || s=="na") return 1
        return 0
      }
      function yes(s){ s=tolower(trim(s)); return (s=="yes"||s=="y"||s=="true"||s=="✓"||s=="x"||s=="done") }
      # find header
      /\|/ && tolower($0) ~ /req-id/ && tolower($0) ~ /verified-by/ {
        n=split($0, h, "|")
        for (i=1;i<=n;i++){
          hc=tolower(trim(h[i]))
          if (hc ~ /req-id/)        col_id=i
          if (hc ~ /in-scope/)      col_scope=i
          if (hc ~ /built/)         col_built=i
          if (hc ~ /evidence|evidencia/) col_ev=i
          if (hc ~ /verified-by/)   col_vb=i
        }
        inmatrix=1; seen_sep=0; next
      }
      inmatrix && /\|/ {
        # separator row like |---|---|
        if ($0 ~ /^[ \t]*\|[ \t:|-]+\|[ \t]*$/) { seen_sep=1; next }
        if (!seen_sep) next
        # blank line / end of table
        if (trim($0) == "") { inmatrix=0; next }
        split($0, cells, "|")
        id=trim(cells[col_id])
        if (id=="" ) next
        scope=cells[col_scope]; built=cells[col_built]; ev=cells[col_ev]; vb=cells[col_vb]
        if (!yes(scope)) next                      # only in-scope rows are gated
        rows++
        problems=""
        if (!yes(built))  problems = problems " built≠yes"
        if (empty(ev))    problems = problems " no-evidence"
        if (empty(vb))    problems = problems " no-verified-by"
        else {
          v=tolower(trim(vb))
          if (v=="executor" || v=="ejecutor" || v=="self" || v=="same" || v ~ /≠/) problems = problems " verified-by-not-independent"
        }
        if (problems != "") { bad++; printf("  [%s] %s ->%s\n", FILE, id, problems) }
      }
      END { if (rows==0) printf("__NOROWS__ %s\n", FILE) }
    ' "$f"
  done
)"

violations="$(printf '%s\n' "$report" | grep -v '__NOROWS__' | grep -E '\->' || true)"
norows="$(printf '%s\n' "$report" | grep '__NOROWS__' || true)"

if [ -n "$violations" ]; then
  {
    echo "FORGE BLOCK — Acceptance Matrix is not COMPLETE. Cannot declare done / open PR."
    echo "GREEN (tests pass on what exists) ≠ COMPLETE (every in-scope requirement traced to evidence + independently verified)."
    echo "Incomplete in-scope rows:"
    printf '%s\n' "$violations"
    echo ""
    echo "Each in-scope row needs: built=yes + non-empty evidence + verified-by ≠ executor."
    echo "Run the independent-verifier agent, fill the evidence, then retry."
  } >&2
  exit 2
fi

if [ -n "$norows" ] && [ "${FORGE_REQUIRE_MATRIX:-0}" = "1" ]; then
  echo "FORGE BLOCK: an Acceptance Matrix heading was found but has no in-scope rows ($norows)." >&2
  exit 2
fi

echo "forge: Acceptance Matrix COMPLETE — all in-scope rows built + evidenced + independently verified." >&2
exit 0
