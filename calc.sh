#!/usr/bin/env bash
# calc.sh — applies one arithmetic operation to two numbers.
#
# Usage: calc.sh <number> <operator> <number>
#   operators: +  -  /
#
# bc does the arithmetic.

a=$1 op=$2 b=$3

# If bc fails (say it is not installed), its own error shows and calc.sh exits
# with its status, printing no result. bc wraps a long result with "\" and a
# newline; join it back onto one line.
result=$(bc <<< "$a $op $b") || exit
result=${result//$'\\\n'/}
echo "$result"
