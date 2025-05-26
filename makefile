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
##   version - 1.0.0
##   created - 2025-05-26
##   modified - 2025-05-26
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <GNU GPLv3 at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - echo, rm
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jvs_ja>
##   * <Bug report at https://github.com/qq542vev/jvs_ja/issues>

# Sp Targets
# ==========

.POSIX:

.PHONY: all clean rebuild help version

.SILENT: help version

# Macro
# =====

FILES = xml-export-en.html.xml xml-export-jbo.html.xml xml-export.html.xml
COMMAND = . './jbovlaste-auth' && bin/cupra-lo-jbovlaste-vreji.sh --curl-option '--silent' --curl-option '--show-error' 
VERSION = 1.0.0

# Build
# =====

all: $(FILES)

xml-export-en.html.xml:
	 $(COMMAND) en $(@)

xml-export-jbo.html.xml:
	 $(COMMAND) jbo $(@)

xml-export.html.xml:
	 $(COMMAND) ja $(@)

# Clean
# =====

clean:
	rm -f -- $(FILES)

rebuild: clean all

# Message
# =======

help:
	echo 'ファイルの作成・検証を行う。'
	echo
	echo 'USAGE:'
	echo '  make [OPTION...] [MACRO=VALUE...] [TARGET...]'
	echo
	echo 'TARGET:'
	echo '  all     全てのファイルを作成する。'
	echo '  clean   作成したファイルを削除する。'
	echo '  rebuild cleanの後にallを実行する。'
	echo '  help    このヘルプを表示して終了する。'
	echo '  version バージョン情報を表示して終了する。'

version:
	echo '$(VERSION)'
