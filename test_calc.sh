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

# fails <message> <args...> — calc.sh prints nothing on stdout, an error
# containing <message> on stderr, and exits 1.
fails() {
  local want=$1
  shift
  run "$@"
  if [[ $status -eq 1 && -z $out && $err == *"$want"* ]]; then
    pass "calc.sh $* — refused"
  else
    fail "calc.sh $* — want an error containing '$want', exit 1; got '$out', exit $status, stderr '$err'"
  fi
}

# AC-001, AC-002
ok 5 2 + 3
ok 6 10 - 4
ok 4 8 / 2
# An 81-digit result, longer than bc's line, prints on one line.
zeros=$(printf '%080d' 0)
ok "1$zeros" "${zeros//0/9}" + 1

# AC-003
ok 12 3 x 4
ok 12 3 '*' 4

# AC-008, AC-009, AC-010
fails 'division by zero' 5 / 0
fails "not a number: 'abc'" 5 + abc
fails "unknown operator: '%'" 5 % 2
fails 'missing the second number' 5 +
# No arguments, four arguments, an empty operand.
fails 'missing both numbers and the operator'
fails 'too many arguments' 1 + 2 3
fails "not a number: ''" '' + 5

# AC-004, AC-005
ok 3.75 1.5 + 2.25
ok -1 -3 - -2
# Not numbers: no digit before or after the point, a plus sign, an exponent.
fails "not a number: '.5'" .5 + 1
fails "not a number: '5.'" 5. + 1
fails "not a number: '+5'" +5 + 1
fails "not a number: '1e3'" 1e3 + 1
# A zero divisor written with a point or a minus.
fails 'division by zero' 5 / 0.0
fails 'division by zero' 5 / -0

# AC-006, AC-007
ok 3.5 7 / 2
ok 3.33 10 / 3
ok 0.67 2 / 3
ok 0.3 0.1 + 0.2
# Halfway rounds away from zero; a negative zero prints as 0.
ok 0.13 0.25 / 2
ok -0.13 -0.25 / 2
ok 0 -0.001 x 1

echo "$passed passed, $failed failed"
[[ $failed -eq 0 ]]
