#!/usr/bin/env bash
# calc.sh — applies one arithmetic operation to two numbers.
#
# Usage: calc.sh <number> <operator> <number>
#   operators: +  -  x or * (quote it on the command line: '*')  /
#
# bc does the arithmetic. Bad input prints an error to stderr, nothing to
# stdout, and exits 1.

usage='usage: calc.sh <number> <operator> <number>'
# A number is an optional minus, digits, and an optional .digits.
number='^-?[0-9]+([.][0-9]+)?$'
zero='^-?0+([.]0+)?$'

die() {
  echo "calc.sh: $1" >&2
  exit 1
}

case $# in
  0) die "missing both numbers and the operator; $usage" ;;
  1) die "missing the operator and the second number; $usage" ;;
  2) die "missing the second number; $usage" ;;
  3) ;;
  *) die "too many arguments ($#, expected 3); $usage" ;;
esac

a=$1 op=$2 b=$3

[[ $a =~ $number ]] || die "not a number: '$a'"
# x and * both multiply. $op is only ever used quoted or as a case word, so
# the shell never expands a *.
case $op in
  + | - | /) ;;
  x | '*') op='*' ;;
  *) die "unknown operator: '$op' (use +, -, x, * or /)" ;;
esac
[[ $b =~ $number ]] || die "not a number: '$b'"
[[ $op == / && $b =~ $zero ]] && die "division by zero"

# If bc fails (say it is not installed), its own error shows and calc.sh exits
# with its status, printing no result. bc wraps a long result with "\" and a
# newline; join it back onto one line.
result=$(bc <<< "$a $op $b") || exit
result=${result//$'\\\n'/}
echo "$result"
