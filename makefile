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
##   version - 1.3.0
##   created - 2025-05-26
##   modified - 2025-05-27
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

.PHONY: all git-commit git-recommit clean rebuild help version

.SILENT: help version

# Macro
# =====

FILE = xml-export-en.html.xml xml-export-jbo.html.xml xml-export.html.xml
CMD = . './auth' && bin/cupra-lo-jbovlaste-vreji.sh --curl-option '--silent' --curl-option '--show-error'
COMMIT_MSG = .i de'i li %Y-%m-%d ti'u li %H:%M:%SZ cu cpacu le datni
VERSION = 1.3.0

# Build
# =====

all: $(FILE)

xml-export-en.html.xml:
	 $(CMD) en $(@)

xml-export-jbo.html.xml:
	 $(CMD) jbo $(@)

xml-export.html.xml:
	 $(CMD) ja $(@)

# Git
# ===

git-commit: all
	git add -- $(FILE)
	if ! git diff --cached --quiet -- $(FILE); then \
		git commit -m"$$(date -u "+${COMMIT_MSG}")" -- $(FILE); \
	fi

git-recommit: clean git-commit

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
	echo '  git-recommit'
	echo '          cleanを実行後にgit-commitを実行する。'
	echo '  clean   作成したファイルを削除する。'
	echo '  rebuild clean実行後にallを実行する。'
	echo '  help    このヘルプを表示して終了する。'
	echo '  version バージョン情報を表示して終了する。'

version:
	echo '$(VERSION)'
