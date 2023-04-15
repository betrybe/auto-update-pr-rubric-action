#!/bin/bash

git config user.name "trybe-tech-ops"
git config user.email "trybe-tech-ops@users.noreply.github.com"

branches=("rubrica" "rubrica-vazia" "rubrica-parcial" "rubrica-quebrando-lint")

if [[ $? -eq 0 ]] ; then
  branch="master"
else
  branch="main"
fi

for branch in ${branches[@]}; do
  echo "---------------------------"
  echo "📝 Working on $branch"
  git checkout $branch
  message=`git merge $branch --no-commit --no-ff 2>&1`
  
  case $message in
    *"CONFLICT"*)
      git merge --abort
      git commit --allow-empty -m "🤖 There was an attempt to update the branch that failed. Resolve conflicts and update manually"
      echo "❌ Merge with conflicts. Resolve and merge manually!"
      ;;
    *"Already up to date"*)
      echo "✅ Branch '$branch' is already up to date."
      ;;
    *"Automatic merge went well"*)
      git merge --abort
      echo "Merge without conflicts."
      git merge main --no-edit -m "🤖 Merged by betrybe/auto-update-rubric-pr-action"
      git push origin $branch
      echo "✅ Branch '$branch' was updated successfully!"
      ;;
    *)
      echo "⚠️ Unexpected message returned."
  esac

done
