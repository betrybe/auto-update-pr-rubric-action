#!/bin/bash
set -e

branches=("rubric" "rubrica-vazia")

git config user.name "Update branch"
git config user.email github-actions@github.com

for branch in ${branches[@]}; do
  echo "Working on $branch"
  git checkout $branch
  git merge --no-commit --no-ff main && err=$? || err=$?
  git merge --abort
  if [ $err -eq 1 ] ; then
    echo "❌ Merge with conflicts. Resolve and merge manually"
  else
    echo "Merge without conflicts"
    git merge main --no-edit -m "Merged by auto-update-rubric-pr-action"
    git push origin $branch
    echo "✅ Branch '$branch' was updated successfully"
  fi
done