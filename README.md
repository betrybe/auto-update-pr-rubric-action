# GitHub Action: Auto Update Pull Request at Rubrics

When an update occurs on the major branch (`master` or `main`), this action will be triggered.

This will execute a sequence of commands to try to merge the major branch into the four project heading branches.

The branches to be updated are:

- rubrica
- rubrica-vazia
- rubrica-parcial
- rubrica-quebrando-lint

## Usage

To use this action in a project it is necessary to add a yml file, with any name, in the folder `./.github/workflows/` with the code below.

Example: `./.github/workflows/action.yml`

```yaml
on:
  push:
    branches:
      - main

jobs:
  update:
    name: Update Rubric's Pull Request
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Fetch Action
        uses: actions/checkout@v3
        with:
          repository: betrybe/auto-update-pr-rubric-action
          ref: main
          path: .github/actions/update
      - name: Run Update Rubric PR
        uses: ./.github/actions/update
```
