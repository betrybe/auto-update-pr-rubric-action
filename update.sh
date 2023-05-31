#!/bin/bash

set -x

git config user.name "trybe-tech-ops"
git config user.email "trybe-tech-ops@users.noreply.github.com"

source_branch=$INPUT_SOURCE_BRANCH
target_branches=$INPUT_TARGET_BRANCHES
target_label=$INPUT_TARGET_LABEL
update_all_branches=$INPUT_ALL_BRANCHES

if [ "$update_all_branches" = "true" ]; then
  all_branches=$(git ls-remote --heads origin | sed 's?.*refs/heads/??')
else
  if [ -n "$target_label" ]; then
    # Extract owner and repository name from GITHUB_REPOSITORY
    IFS='/' read -r owner repository <<<"$GITHUB_REPOSITORY"

    query="
    {
      repository(owner: \\\"$owner\\\", name: \\\"$repository\\\") {
        pullRequests(first: 100, labels: [\\\"$target_label\\\"], states: OPEN) {
          edges {
            node {
              headRefName
            }
          }
        }
      }
    }
    "
    query=${query//$'\n'/ }

    # Fetch pull requests with the 'rubric' label
    response=$(curl -s -H "Authorization: bearer $INPUT_TOKEN" -X POST -d "{ \"query\": \"$query\" }" https://api.github.com/graphql)

    # Extract branch names from the response
    label_branches=$(echo "$response" | jq -r '.data.repository.pullRequests.edges[].node.headRefName')

    label_branches=${label_branches//$'\n'/ }
  fi

  all_branches=$(echo "$target_branches $label_branches" | awk -v RS=" " '!seen[$0]++' | paste -sd " ")
fi

# function for updating branches
function update_branch() {
  for target_branch in $1; do
    echo "---------------------------"
    echo "📝 Working on $target_branch"
    git checkout "$target_branch"
    message=$(git merge "$2" --no-commit --no-ff 2>&1)

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
}

# Begin in the source branch
git checkout "$source_branch"
IFS=" "

update_branch "$all_branches" "$source_branch"
