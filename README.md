# GitHub Action: Run ktlint with reviewdog

This action runs [ktlint](https://ktlint.github.io/) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests
to enforce best practices.

## Examples

### With `github-pr-check`

By default, with `reporter: github-pr-check` an annotation is added to
the line:
![Example comment made by the action, with github-pr-check](./github-pr-check.png)

### With `github-pr-review`

With `reporter: github-pr-review` a comment is added to
the Pull Request Conversation:
![Example comment made by the action, with github-pr-review](./github-pr-review.png)

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`.

### `level`

Optional. Report level for reviewdog [`info`,`warning`,`error`].
It's same as `-level` flag of reviewdog.
The default is `error`.

### `reporter`

Optional. Reporter of reviewdog command [`github-pr-check`,`github-pr-review`].
The default is `github-pr-check`.

### `fail_on_error`

Optional. Fails the current check if any error was found [`true`/`false`]
The default value is false.

### `filter_mode`
Optional. Filter mode of reviewdog command [`added`,`diff_context`,`file`,`nofilter`]
Default is `added`.

### `relative`

Optional. Print files relative to the working directory [`true`/`false`]
The default value is true.

### `android`

Optional. Runs KtLint with [Android Kotlin Style Guide](https://android.github.io/kotlin-guides/style.html) [`true`/`false`]
The default value is false.

## Example usage

```yml
name: reviewdog
on: [pull_request]
jobs:
  ktlint:
    name: Check Code Quality
    runs-on: ubuntu-latest

    steps:
      - name: Clone repo
        uses: actions/checkout@master
        with:
          fetch-depth: 1
      - name: ktlint
        uses: ScaCap/action-ktlint@master
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review # Change reporter
```
