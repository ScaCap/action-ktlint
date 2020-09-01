#!/bin/sh

export RELATIVE=
export ANDROID=
export KTLINT_RELEASE=

if [ "$INPUT_KTLINT_VERSION" = "latest" ] ; then
  export KTLINT_RELEASE="https://api.github.com/repos/pinterest/ktlint/releases/latest"
else
  export KTLINT_RELEASE="https://github.com/pinterest/ktlint/releases/download/${INPUT_KTLINT_VERSION}/ktlint"
fi

echo ktlint release version: "${KTLINT_RELEASE}"

curl -sSL "${KTLINT_RELEASE}" \
    | grep "browser_download_url.*ktlint\"" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -\
    && chmod a+x ktlint \
    && mv ktlint /usr/local/bin/

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
