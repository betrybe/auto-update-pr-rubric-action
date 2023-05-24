#!/bin/bash

set -x

git config user.name "trybe-tech-ops"
git config user.email "trybe-tech-ops@users.noreply.github.com"

source_branch=$INPUT_SOURCE_BRANCH
target_branches=$INPUT_TARGET_BRANCHES

git checkout "$source_branch"

IFS=" "

for target_branch in $target_branches; do
  echo "---------------------------"
  echo "📝 Working on $target_branch"
  git checkout "$target_branch"
  message=$(git merge "$source_branch" --no-commit --no-ff 2>&1)

  case $message in
  *"CONFLICT"*)
    git merge --abort
    git commit --allow-empty -m "🤖 There was an attempt to update the branch that failed. Resolve conflicts and update manually"
    echo "❌ Merge with conflicts. Resolve and merge manually!"
    ;;
  *"Already up to date"*)
    echo "✅ Branch '$target_branch' is already up to date."
    ;;
  *"Automatic merge went well"*)
    git merge --abort
    echo "Merge without conflicts."
    git merge main --no-edit -m "🤖 Merged by betrybe/auto-update-rubric-pr-action"
    git push origin "$target_branch"
    echo "✅ Branch '$target_branch' was updated successfully!"
    ;;
  *)
    echo "⚠️ Unexpected message returned."
    ;;
  esac

done
