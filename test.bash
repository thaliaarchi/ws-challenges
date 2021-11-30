#!/bin/bash

BUILD=build

make all run_tests

find . -not \( -type d -path "./$BUILD" -prune \) -type f -name '*.out' | sort -V |
while read -r out; do
  name="${out#./}"
  echo "${name%.out}"
  diff "$out" "$BUILD/$out"
done
