#!/bin/sh -l
set -e

branches=("rubric")

git config user.name "Update branch"
git config user.email github-actions@github.com

for branch in ${branches[@]}; do
  echo "Working on $branch"
  git checkout $branch
  git merge --no-commit --no-ff main ||
  conflicts=$?
  if [ "$conflicts" -eq "1" ] ; then
    git merge --abort
    echo "❌ Merge with conflicts. Resolve and merge manually"
  else
    echo "Merge without conflicts"
    git merge --abort
    git merge main --no-edit -m "Merged by auto-update-rubric-pr-action"
    git push origin $branch
    echo "✅ Branch '$branch' was updated successfully"
  fi
done