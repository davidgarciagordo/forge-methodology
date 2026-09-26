#!/usr/bin/env bash
# Regression tests for hooks/check-acceptance-matrix.sh.
# Asserts exit codes and offending req-ids only — never the message wording.
# Usage: bash tests/hook.test.sh   (deps: bash, git, awk, grep)

set -u

HOOK="$(cd "$(dirname "$0")/.." && pwd)/hooks/check-acceptance-matrix.sh"
PR_PAYLOAD='{"tool_input":{"command":"gh pr create --fill"}}'
pass=0
fail=0
tmp_dirs=()

cleanup() { for d in "${tmp_dirs[@]}"; do rm -rf "$d"; done; }
trap cleanup EXIT

HEADER='| req-id | source | in-scope? | built? | evidence | verified-by |'
SEP='|---|---|---|---|---|---|'

# new_repo → prints the path of a fresh, empty git repo
new_repo() {
  local d
  d="$(mktemp -d)"
  tmp_dirs+=("$d")
  git -C "$d" init -q
  printf '%s' "$d"
}

# write_spec <repo> <relpath> <row>... → writes an Acceptance Matrix with the given rows
write_spec() {
  local repo="$1" rel="$2"; shift 2
  mkdir -p "$(dirname "$repo/$rel")"
  { echo "## Acceptance Matrix"; echo; echo "$HEADER"; echo "$SEP"; printf '%s\n' "$@"; } > "$repo/$rel"
}

# run_hook <repo> <payload> [VAR=value...] → sets $rc and $err
run_hook() {
  local repo="$1" payload="$2"; shift 2
  err="$(cd "$repo" && printf '%s' "$payload" | env "$@" bash "$HOOK" 2>&1 >/dev/null)"
  rc=$?
}

check() {
  local name="$1" cond="$2"
  if eval "$cond"; then pass=$((pass + 1)); echo "ok   - $name"
  else fail=$((fail + 1)); echo "FAIL - $name (rc=$rc)"; printf '%s\n' "$err" | sed 's/^/       /'
  fi
}

COMPLETE_ROW='| R1 | ref §1 | yes | yes | tests/a.test | independent-verifier |'

# 1. A non-"declare done" command is never gated.
r="$(new_repo)"; write_spec "$r" .forge/spec.md '| R1 | ref | yes | no | — | — |'
run_hook "$r" '{"tool_input":{"command":"ls -la"}}'
check "non-done command passes" '[ "$rc" -eq 0 ]'

# 2. A bare "forge-done" word (no brackets) is not a marker.
run_hook "$r" '{"tool_input":{"command":"git commit -m \"x forge-done\""}}'
check "bare forge-done is not gated" '[ "$rc" -eq 0 ]'

# 3. gh pr create with incomplete rows blocks and names only the offending req-ids.
write_spec "$r" .forge/spec.md "$COMPLETE_ROW" \
  '| R2 | ref §2 | yes | yes | — | — |' \
  '| R3 | ref §3 | yes | no | — | — |' \
  '| R4 | ref §4 | no | — | — | — |'
run_hook "$r" "$PR_PAYLOAD"
check "incomplete matrix blocks with exit 2" '[ "$rc" -eq 2 ]'
check "R2 and R3 reported" 'grep -q "R2 ->" <<<"$err" && grep -q "R3 ->" <<<"$err"'
check "R1 (complete) and R4 (out of scope) not reported" '! grep -qE "R1 ->|R4 ->" <<<"$err"'
check "offending file shown relative to repo root" 'grep -qF "[.forge/spec.md] R2 ->" <<<"$err"'

# 4. The opt-in markers gate commits too.
run_hook "$r" '{"tool_input":{"command":"git commit -m \"feat: x [forge-done]\""}}'
check "[forge-done] marker blocks" '[ "$rc" -eq 2 ]'
run_hook "$r" '{"tool_input":{"command":"FORGE_DONE=1 git push"}}'
check "FORGE_DONE=1 marker blocks" '[ "$rc" -eq 2 ]'

# 5. A complete matrix passes.
write_spec "$r" .forge/spec.md "$COMPLETE_ROW" '| R2 | ref §2 | no | — | — | — |'
run_hook "$r" "$PR_PAYLOAD"
check "complete matrix passes" '[ "$rc" -eq 0 ]'

# 6. verified-by equal to the executor placeholder fails independence.
for who in executor ejecutor self same; do
  write_spec "$r" .forge/spec.md "| R9 | ref | yes | yes | tests/x | $who |"
  run_hook "$r" "$PR_PAYLOAD"
  check "verified-by=$who blocks" '[ "$rc" -eq 2 ] && grep -q "R9 ->" <<<"$err"'
done

# 7. Accepted in-scope spellings gate the row.
for v in yes y true x done ✓; do
  write_spec "$r" .forge/spec.md "| R5 | ref | $v | no | — | — |"
  run_hook "$r" "$PR_PAYLOAD"
  check "in-scope=$v is gated" '[ "$rc" -eq 2 ] && grep -q "R5 ->" <<<"$err"'
done

# 8. No matrix: fail-open by default, blocking with FORGE_REQUIRE_MATRIX=1.
r="$(new_repo)"
run_hook "$r" "$PR_PAYLOAD"
check "no matrix passes by default" '[ "$rc" -eq 0 ]'
run_hook "$r" "$PR_PAYLOAD" FORGE_REQUIRE_MATRIX=1
check "no matrix blocks with FORGE_REQUIRE_MATRIX=1" '[ "$rc" -eq 2 ]'

# 9. A template-marked spec is skipped.
r="$(new_repo)"
write_spec "$r" .forge/spec.md '| R1 | ref | yes | no | — | — |'
printf '<!-- forge:template -->\n%s\n' "$(cat "$r/.forge/spec.md")" > "$r/.forge/spec.md"
run_hook "$r" "$PR_PAYLOAD"
check "template-marked spec is skipped" '[ "$rc" -eq 0 ]'

# 10. Malformed header (no in-scope column) gates zero rows: pass by default, block when required.
r="$(new_repo)"
{ echo "## Acceptance Matrix"; echo; echo '| req-id | built? | evidence | verified-by |'; echo '|---|---|---|---|'
  echo '| R1 | no | — | — |'; } > "$r/.forge-spec.md"
git -C "$r" add .forge-spec.md
run_hook "$r" "$PR_PAYLOAD"
check "malformed header does not block by default" '[ "$rc" -eq 0 ]'
run_hook "$r" "$PR_PAYLOAD" FORGE_REQUIRE_MATRIX=1
check "malformed header blocks with FORGE_REQUIRE_MATRIX=1" '[ "$rc" -eq 2 ]'

# 11. Discovery: only git-tracked *.md gate; FORGE_ACCEPTANCE_MATRIX overrides the scan.
r="$(new_repo)"
write_spec "$r" docs/spec.md '| R7 | ref | yes | no | — | — |'
run_hook "$r" "$PR_PAYLOAD"
check "untracked spec does not gate" '[ "$rc" -eq 0 ]'
git -C "$r" add docs/spec.md
run_hook "$r" "$PR_PAYLOAD"
check "tracked spec gates" '[ "$rc" -eq 2 ] && grep -q "R7 ->" <<<"$err"'
write_spec "$r" active.md "$COMPLETE_ROW"
run_hook "$r" "$PR_PAYLOAD" FORGE_ACCEPTANCE_MATRIX="$r/active.md"
check "FORGE_ACCEPTANCE_MATRIX overrides the scan" '[ "$rc" -eq 0 ]'

echo
echo "passed: $pass  failed: $fail"
[ "$fail" -eq 0 ]
