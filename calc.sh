#!/usr/bin/env bash
# calc.sh — applies one arithmetic operation to two numbers.
#
# Usage: calc.sh <number> <operator> <number>
#   operators: +  -  x or * (quote it on the command line: '*')  /
#
# bc does the arithmetic.

a=$1 op=$2 b=$3

# x and * both multiply. $op is only ever used quoted or as a case word, so
# the shell never expands a *.
case $op in
  x | '*') op='*' ;;
esac

# If bc fails (say it is not installed), its own error shows and calc.sh exits
# with its status, printing no result. bc wraps a long result with "\" and a
# newline; join it back onto one line.
result=$(bc <<< "$a $op $b") || exit
result=${result//$'\\\n'/}
echo "$result"
