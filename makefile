#!/usr/bin/make -f

### File: makefile
##
## ファイルの作成・検証を行う。
##
## Usage:
##
## ------ Text ------
## make -f makefile
## ------------------
##
## Metadata:
##
##   id - 02afb1e6-527b-451a-b5e2-f29646322122
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 2.0.1
##   created - 2025-05-26
##   modified - 2025-06-05
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - curl, echo, git, rm
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jvs_ja>
##   * <Bug report at https://github.com/qq542vev/jvs_ja/issues>

# Sp Targets
# ==========

.POSIX:

.PHONY: all FORCE git-commit clean rebuild help version

.SILENT: help version

# Macro
# =====

FILE = xml-export-en.html.xml xml-export-jbo.html.xml xml-export.html.xml
CMD = . './auth' && bin/cupra-lo-jbovlaste-vreji.sh --curl-option '--silent' --curl-option '--show-error'
COMMIT_MSG = .i de'i li %Y-%m-%d ti'u li %H:%M:%SZ cu cpacu le datni
VERSION = 2.0.1

# Build
# =====

all: $(FILE)

xml-export-en.html.xml: FORCE
	$(CMD) en $(@) || case "$${?}" in \
		1) :;; \
		*) exit "$${?}";; \
	esac

xml-export-jbo.html.xml: FORCE
	$(CMD) jbo $(@) || case "$${?}" in \
		1) :;; \
		*) exit "$${?}";; \
	esac

xml-export.html.xml: FORCE
	$(CMD) ja $(@) || case "$${?}" in \
		1) :;; \
		*) exit "$${?}";; \
	esac

FORCE:

# Git
# ===

git-commit: all
	git add -- $(FILE)
	if ! git diff --cached --quiet -- $(FILE); then \
		git commit -m"$$(date -u "+${COMMIT_MSG}")" -- $(FILE); \
	fi

# Docs
# ====

LICENSE.txt:
	curl -sS -f -L -o '$(@)' -- 'https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt'

# Clean
# =====

clean:
	rm -f -- $(FILE)

rebuild: clean all

# Message
# =======

help:
	echo 'ファイルの作成・検証を行う。'
	echo
	echo 'USAGE:'
	echo '  make [OPTION...] [MACRO=VALUE...] [TARGET...]'
	echo
	echo 'MACRO:'
	echo '  FILE       作成・削除・コミット時の対象ファイル。'
	echo '  COMMIT_MSG git-commit実行時のコミットメッセージ。'
	echo
	echo 'TARGET:'
	echo '  all     全てのファイルを作成する。'
	echo '  git-commit'
	echo '          allを実行後にgit commitを実行する。'
	echo '  clean   作成したファイルを削除する。'
	echo '  rebuild clean実行後にallを実行する。'
	echo '  help    このヘルプを表示して終了する。'
	echo '  version バージョン情報を表示して終了する。'

version:
	echo '$(VERSION)'
