#!/usr/bin/env bash
# test_calc.sh — runs every calc.sh case and exits non-zero if any fails.
# Usage: bash test_calc.sh

cd "$(dirname "$0")" || exit 1
errfile=$(mktemp) || exit 1
trap 'rm -f "$errfile"' EXIT
passed=0
failed=0

# run <args...> — runs ./calc.sh and sets out, err and status.
run() {
  out=$(./calc.sh "$@" 2>"$errfile")
  status=$?
  err=$(<"$errfile")
}

pass() { passed=$((passed + 1)); echo "ok    $1"; }
fail() { failed=$((failed + 1)); echo "FAIL  $1"; }

# ok <want> <args...> — calc.sh prints exactly <want> on one line, nothing on
# stderr, and exits 0.
ok() {
  local want=$1
  shift
  run "$@"
  if [[ $status -eq 0 && $out == "$want" && -z $err ]]; then
    pass "calc.sh $*"
  else
    fail "calc.sh $* — want '$want', exit 0; got '$out', exit $status, stderr '$err'"
  fi
}

# AC-001, AC-002
ok 5 2 + 3
ok 6 10 - 4
ok 4 8 / 2
# An 81-digit result, longer than bc's line, prints on one line.
zeros=$(printf '%080d' 0)
ok "1$zeros" "${zeros//0/9}" + 1

echo "$passed passed, $failed failed"
[[ $failed -eq 0 ]]
