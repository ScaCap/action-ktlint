#!/bin/sh

export RELATIVE=
export ANDROID=
export BASELINE=

if [ "$INPUT_FAIL_ON_ERROR" = true ] ; then
  set -o pipefail
fi

if [ "$INPUT_RELATIVE" = true ] ; then
  export RELATIVE=--relative
fi

if [ ! -z "$INPUT_BASELINE" ] ; then
  export BASELINE="--baseline=${INPUT_BASELINE}"
fi

if [ "$INPUT_ANDROID" = true ] ; then
  export ANDROID=--android
fi

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo KtLint version: "$(ktlint --version)"
ktlint --reporter=checkstyle $RELATIVE $ANDROID $BASELINE \
  | reviewdog -f=checkstyle -name="ktlint" -reporter="${INPUT_REPORTER}" -level="${INPUT_LEVEL}"
