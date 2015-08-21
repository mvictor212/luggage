#!/bin/sh
git branch $* | sed 's/^[* ] //' | while read branch; do
  echo
  echo
  echo "--------------------------------------"
  echo "$branch"
  echo "--------------------------------------"
  git branch --contains $branch -a
done
