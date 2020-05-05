#!/bin/sh

if [ "$INPUT_FAIL_ON_ERROR" = true ] ; then
  set -o pipefail
fi

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

ktlint --reporter=checkstyle \
  | reviewdog -f=checkstyle -name="ktlint" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}"
