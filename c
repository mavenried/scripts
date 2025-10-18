#!/bin/bash
for file in $@; do
  gcc -o /tmp/E-out "$file" -lm
  /tmp/E-out
  rm /tmp/E-out
done
