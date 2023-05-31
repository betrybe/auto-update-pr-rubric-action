# GitHub Action: Auto Update Pull Request at Rubrics

This action will try to merge a source branch into target rubric branches.

The default source branch is `main`.

The default target branches to be updated are:

- rubrica
- rubrica-vazia
- rubrica-parcial
- rubrica-quebrando-lint

## Usage

### Inputs

| Name | Description | Required | Default |
| --- | --- | --- | --- |
| `token` | The GitHub token to be used to update the branches | true | |
| `source_branch` | The source branch to be merged into target branches | false | `main` |
| `target_branches` | The target branches to be updated, space separated | false | `rubrica rubrica-vazia rubrica-parcial rubrica-quebrando-lint` |
| `target_label` | The label to be added to the pull request | false | `rubrica` |
| `all_branches` | If `true`, all branches will be updated | false | `false` |

To use this action in a project it is necessary to add a yml file, with any name, in the folder `./.github/workflows/` with the code below.

Example: `./.github/workflows/auto-update-rubrics.yml`

```yaml
on:
  push:
    branches:
      - main

jobs:
  update:
    name: Auto Update Rubric's Pull Request
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          token: ${{ secrets.GIT_HUB_PAT }}
          fetch-depth: 0
      - name: Fetch Update Rubric Branches
        uses: actions/checkout@v3
        with:
          repository: betrybe/auto-update-pr-rubric-action
          ref: v1.0.0
          path: .github/actions/update
      - name: Run Update Rubric Branches
        uses: ./.github/actions/update
        with:
          token: ${{ secrets.GIT_HUB_PAT }}
          # source_branch: 'main'
          # target_branches: 'rubrica rubrica-vazia rubrica-parcial rubrica-quebrando-lint'
          # target_label: 'rubrica'
          # all_branches: 'false'
```
