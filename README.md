<p align="center">
    <a href="https://github.com/ActionsToolbox/">
        <img src="https://cdn.wolfsoftware.com/assets/images/github/organisations/actionstoolbox/black-and-white-circle-256.png" alt="ActionsToolbox logo" />
    </a>
    <br />
    <a href="https://github.com/ActionsToolbox/caretaker-action/actions/workflows/cicd-pipeline.yml">
        <img src="https://img.shields.io/github/workflow/status/ActionsToolbox/caretaker-action/CICD%20Pipeline/master?style=for-the-badge" alt="Github Build Status">
    </a>
    <a href="https://github.com/ActionsToolbox/caretaker-action/releases/latest">
        <img src="https://img.shields.io/github/v/release/ActionsToolbox/caretaker-action?color=blue&label=Latest%20Release&style=for-the-badge" alt="Release">
    </a>
    <a href="https://github.com/ActionsToolbox/caretaker-action/releases/latest">
        <img src="https://img.shields.io/github/commits-since/ActionsToolbox/caretaker-action/latest.svg?color=blue&style=for-the-badge" alt="Commits since release">
    </a>
    <br />
    <a href=".github/CODE_OF_CONDUCT.md">
        <img src="https://img.shields.io/badge/Code%20of%20Conduct-blue?style=for-the-badge" />
    </a>
    <a href=".github/CONTRIBUTING.md">
        <img src="https://img.shields.io/badge/Contributing-blue?style=for-the-badge" />
    </a>
    <a href=".github/SECURITY.md">
        <img src="https://img.shields.io/badge/Report%20Security%20Concern-blue?style=for-the-badge" />
    </a>
    <a href="https://github.com/ActionsToolbox/caretaker-action/issues">
        <img src="https://img.shields.io/badge/Get%20Support-blue?style=for-the-badge" />
    </a>
    <br />
    <a href="https://wolfsoftware.com/">
        <img src="https://img.shields.io/badge/Created%20by%20Wolf%20Software-blue?style=for-the-badge" />
    </a>
</p>

## Caretaker

## Inputs

| Name                | Required | Default Value                      | Details                                                                                                                                   |
| ------------------- | -------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| git-push-user-name  | false    |                                    | If empty the name of the GitHub Actions bot will be used (i.e. '''github-actions[bot]''')                                                 |
| git-push-user-email | false    |                                    | If empty the no-reply email of the GitHub Actions bot will be used (i.e. '''github-actions[bot]@users.noreply.github.com''')              |
| git-commit-message  | false    | caretaker-action: automated action | The commit message to use                                                                                                                 |
| output-file         | false    | CHANGELOG.md                       | The name of the changelog file                                                                                                            |
| args                | false    |                                    | Additional arguments to pass to the command (see [full documentation](https://github.com/terraform-docs/terraform-docs/tree/master/docs)) |

> args are currently silently ignored

## Example usage

```yaml
name: Caretaker
on: [push]

jobs:
  caretaker:
    runs-on: ubuntu-latest
    name: Caretaker
    steps:
      - name: Check our repo
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Caretaker
        id: caretaker
        uses: ActionsToolbox/caretaker-action@master
```
