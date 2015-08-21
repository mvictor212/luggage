#!/bin/sh

git fsck $@ | awk '{print $3}' | while read commit; do
  echo "================================================================================"
  echo $commit
  echo "================================================================================"
  git show $commit | cat
done