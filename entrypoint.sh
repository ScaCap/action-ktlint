#!/bin/sh

export RELATIVE=
export ANDROID=

if [ "$INPUT_RELATIVE" = true ] ; then
  export RELATIVE=--relative
fi

if [ "$INPUT_ANDROID" = true ] ; then
  export ANDROID=--android
fi

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo ktlint version: "$(ktlint --version)"

ktlint --reporter=checkstyle $RELATIVE $ANDROID \
  | reviewdog -f=checkstyle \
    -name="ktlint" \
    -reporter="${INPUT_REPORTER}" \
    -level="${INPUT_LEVEL}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}"
