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
| `source_branch` | The source branch to be merged into target branches | false | `main` |
| `target_branches` | The target branches to be updated, space separated | false | `rubrica rubrica-vazia rubrica-parcial rubrica-quebrando-lint` |

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
        # You can override the default values of source_branch and target_branches
        # with:
        #   source_branch: main
        #   target_branches: rubrica rubrica-vazia rubrica-parcial rubrica-quebrando-lint
```
