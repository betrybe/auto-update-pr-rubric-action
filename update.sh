#!/bin/bash
set -e

branches=("rubrica" "rubrica-vazia" "rubrica-parcial" "rubrica-quebrando-lint")

git config user.name "Update branch"
git config user.email github-actions@github.com

for branch in ${branches[@]}; do
  echo "📝 Working on $branch"
  git checkout $branch
  message=`git merge --no-commit --no-ff main`
#   git merge --abort
  case "$message" in
    *"CONFLICT"*)
      git merge --abort
      git commit --allow-empty -m "🤖 There was an attempt to update the branch that failed. Resolve conflicts and update manually"
      echo "❌ Merge with conflicts. Resolve and merge manually!"
    ;;

    *"Already up to date"*)
      echo "✅ Branch '$branch' is already up to date."
    ;;

    *"Automatic merge went well"*)
      echo "Merge without conflicts."
      git merge main --no-edit -m "🤖 Merged by betrybe/auto-update-rubric-pr-action"
      git push origin $branch
      echo "✅ Branch '$branch' was updated successfully!"
    
    *)
      echo "⚠️ Unexpected message returned."
    ;;

  esac

  echo "⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"
done