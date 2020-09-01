FROM alpine:3.12

ARG INPUT_KTLINT_VERSION

ENV REVIEWDOG_VERSION=v0.10.2

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk --no-cache --update add git curl wget openjdk11 \
    && rm -rf /var/cache/apk/*

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN curl -sSL https://api.github.com/repos/pinterest/ktlint/releases/${INPUT_KTLINT_VERSION} \
    | grep "browser_download_url.*ktlint\"" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -\
    && chmod a+x ktlint \
    && mv ktlint /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
