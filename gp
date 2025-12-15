#!/bin/sh
for origin in $(git remote); do
  printf "pushing to \x1b[33m%s\x1b[36m [%s]\x1b[0m\n" "$origin" $(git remote -v | rg push | rg "\b$origin\b" | awk '{print $2}')
  git push "$origin"
done
