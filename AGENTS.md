## Repository Map
- `action.yml`: public action contract, inputs, and Docker action wiring.
- `entrypoint.sh`: runtime logic; downloads `ktlint`, derives version-specific flags, and pipes checkstyle output into `reviewdog`.
- `Dockerfile`: action image build; installs Java, git, curl, wget, and `reviewdog`.
- `.github/workflows/test.yml`: executable truth for PR-facing validation; exercises the local action with multiple reporters.
- `.github/workflows/dockerimage.yml`: executable truth for container-build validation.
- `testdata/`: sample Kotlin fixture for reasoning about lint output.

## Build, Test, and Development Commands
- Run all routine commands from the repository root.
- Build the action image with `docker build . --file Dockerfile --tag "reviewdog-ktlint:$(date +%s)"` when you change `Dockerfile` or `entrypoint.sh`.
- There is no checked-in standalone host-side test command for the action runtime. Use `.github/workflows/test.yml` as the source of truth for supported invocation patterns.
- Treat the runtime pipeline in `entrypoint.sh` as container-only behavior, not a normal local command: it expects GitHub Actions `INPUT_*` variables, `GITHUB_WORKSPACE`, `reviewdog`, and a downloaded `ktlint` binary.
- Use the smallest meaningful validation for the change: image build validation for container changes, and workflow/action metadata review for `action.yml` input or reporter changes.

## PR and Commit Conventions
- No repository-specific PR template, branch naming rule, or commit message convention is evidenced in the checked-in files.
- Do not assume README examples are fresher than workflow files; prefer `.github/workflows/*.yml` and `action.yml` when describing or validating current behavior.

## Constraints and Non-Negotiables
- Do not treat the action as a routine local CLI. Normal execution depends on GitHub Actions-provided `INPUT_*` variables and `GITHUB_WORKSPACE`.
- PR annotation and check reporting are secret-gated: `github_token` is required, and `entrypoint.sh` exports it to `REVIEWDOG_GITHUB_API_TOKEN` before calling `reviewdog`.
- The image build and runtime are network-dependent. `Dockerfile` installs packages and `reviewdog` from remote sources, and `entrypoint.sh` downloads `ktlint` from GitHub releases at runtime.
- For `ktlint` `1.0.1` and later, do not rely on the deprecated `android` input to control code style; use `.editorconfig` instead.
- Keep repo-wide guidance at the root only. There are no nested `AGENTS.md` files in this repository.
