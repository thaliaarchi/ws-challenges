#!/bin/bash

BUILD=build

make -k all run_tests

find . -not \( -type d -path "./$BUILD" -prune \) -type f -name '*.out' | sort -V |
while read -r out; do
  test -f "${out%.out}.wsf" || continue
  out="${out#./}"
  echo "${out%.out}"
  diff "$out" "$BUILD/$out"
done
