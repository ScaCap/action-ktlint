#!/bin/sh

export RELATIVE=
export ANDROID=
export BASELINE=
export CUSTOM_RULE_PATH=

if [ "$INPUT_KTLINT_VERSION" = "latest" ]; then
  curl -sSLO https://github.com/pinterest/ktlint/releases/latest/download/ktlint &&
    chmod a+x ktlint &&
    mv ktlint /usr/local/bin/
else
  curl -sSLO https://github.com/pinterest/ktlint/releases/download/"${INPUT_KTLINT_VERSION}"/ktlint &&
    chmod a+x ktlint &&
    mv ktlint /usr/local/bin/
fi

if [ "$INPUT_RELATIVE" = true ]; then
  export RELATIVE=--relative
fi

if [ ! -z "$INPUT_BASELINE" ]; then
  export BASELINE="--baseline=${INPUT_BASELINE}"
fi

if [ "$INPUT_CUSTOM_RULE_PATH" ]; then
  export CUSTOM_RULE_PATH="--ruleset=${INPUT_CUSTOM_RULE_PATH}"
fi

cd "$GITHUB_WORKSPACE"

git config --global --add safe.directory $GITHUB_WORKSPACE

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

ktlint_version=$(ktlint --version)
# In newer ktlint versions, the command `ktlint --version` returns "ktlint version x.y.z" and we need to remove "ktlint version " from the string
ktlint_version=${ktlint_version#"ktlint version "}


echo "ktlint version: $ktlint_version"

# ktlint_version > 0.49.1
if [ "$(printf '%s\n' "0.49.1" "$ktlint_version" | sort -V | head -n1)" = "0.49.1" ]; then
  echo "ktlint version > 0.49.1"
  # --code-style is deprecated since 1.0.1 and .editorconfig needs to be used: https://pinterest.github.io/ktlint/latest/rules/code-styles/
  # ktlint_version <= 1.0.0
  if [ "$(printf '%s\n' "1.0.0" "$ktlint_version" | sort -V | tail -n1)" = "1.0.0" ]; then
    echo "ktlint version <= 1.0.0"
    if [ "$INPUT_ANDROID" = true ]; then
      export ANDROID="--code-style=android_studio"
    else
      export ANDROID="--code-style=intellij_idea"
    fi
  fi
else
  if [ "$INPUT_ANDROID" = true ]; then
    export ANDROID=--android
  fi
fi

ktlint --reporter=checkstyle $CUSTOM_RULE_PATH $RELATIVE $ANDROID $BASELINE $INPUT_FILE_GLOB |
  reviewdog -f=checkstyle \
    -name="${INPUT_NAME}" \
    -reporter="${INPUT_REPORTER}" \
    -level="${INPUT_LEVEL}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR}"
