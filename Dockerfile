### File: Dockerfile
##
## Dockerイメージを作成する。
##
## Usage:
##
## ------ Text ------
## docker image build -f Dockerfile
## ------------------
##
## Metadata:
##
##   id - 90138cce-c5e0-4c2e-882d-e316ff9677ec
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2025-06-03
##   modified - 2025-06-03
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jvs_ja>
##   * <Bug report at https://github.com/qq542vev/jvs_ja/issues>

ARG BASE="docker.io/library/debian:12-slim"

FROM ${BASE}

ARG BASE
ARG TITLE="jvs_ja"
ARG VERSION="1.0.0"
ARG WORKDIR="/work"

LABEL org.opencontainers.image.title="${TITLE}"
LABEL org.opencontainers.image.description="${TITLE}のビルド・テスト用のイメージ。"
LABEL org.opencontainers.image.authors="qq542vev <https://purl.org/meta/me/>"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.url="https://github.com/qq542vev/jvs_ja"
LABEL org.opencontainers.image.license="GPL-3.0-only"
LABEL org.opencontainers.image.base.name="${BASE}"

ENV LANG="C"
ENV LC_ALL="C"
ENV TZ="UTC0"

WORKDIR ${WORKDIR}

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		cron git make libxml2-utils && \
	rm -rf /var/lib/apt-get/lists/*
