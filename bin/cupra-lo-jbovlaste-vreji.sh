#!/usr/bin/env sh

### Script: cupra-lo-jbovlaste-vreji.sh
##
## .i zmiku cupra lo vreji be fi lo datni be la jbovlastes
##
## Metadata:
##
##   id - 1ef1d1bd-2670-450c-8d5b-42e2e20542f9
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 0.2.2
##   created - 2022-02-08
##   modified - 2025-05-28
##   license - <CC0-1.0 at https://creativecommons.org/publicdomain/zero/1.0/>
##   package - jvs_ja
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/jvs_ja>
##   * <Bug report at https://github.com/qq542vev/jvs_ja/issues>
##   * <jbovlaste: Supported language listings at https://jbovlaste.lojban.org/languages.html>
##   * <jbovlaste: Word Listings: magic user at https://jbovlaste.lojban.org/export/xml.html>
##
## Help Output:
##
## ------ Text ------
## Usage:
##   cupra-lo-jbovlaste-vreji.sh [OPTION]... LANG_TAG FILE
##
## Options:
##   -c,     --curl-option NAME[=VALUE] 
##                               curl option
##           --no-curl-option    reset -c, --curl-option
##   -h,     --help              display this help and exit
##   -v,     --version           output version information and exit
##
## Exit Status:
##     0 - successful termination
##     1 - FILE was not updated
##    64 - command line usage error
##    65 - data format error
##    66 - cannot open input
##    67 - addressee unknown
##    68 - host name unknown
##    69 - service unavailable
##    70 - internal software error
##    71 - system error (e.g., can't fork)
##    72 - critical OS file missing
##    73 - can't create (user) output file
##    74 - input/output error
##    75 - temp failure; user is invited to retry
##    76 - remote error in protocol
##    77 - permission denied
##    78 - configuration error
##   129 - received SIGHUP
##   130 - received SIGINT
##   131 - received SIGQUIT
##   143 - received SIGTERM
## ------------------

readonly 'VERSION=cupra-lo-jbovlaste-vreji.sh 0.2.2'

set -efu
umask '0022'
readonly "LC_ALL_ORG=${LC_ALL-}"
LC_ALL='C'
IFS=$(printf ' \t\n_'); IFS="${IFS%_}"
PATH="${PATH-}${PATH:+:}$(command -p getconf 'PATH')"
UNIX_STD='2003' # HP-UX POSIX mode
XPG_SUS_ENV='ON' # AIX POSIX mode
XPG_UNIX98='OFF' # AIX UNIX 03 mode
POSIXLY_CORRECT='1' # GNU Coreutils POSIX mode
COMMAND_MODE='unix2003' # macOS UNIX 03 mode
export 'LC_ALL' 'IFS' 'PATH' 'UNIX_STD' 'XPG_SUS_ENV' 'XPG_UNIX98' 'POSIXLY_CORRECT' 'COMMAND_MODE'

readonly 'EX_OK=0'           # successful termination
readonly 'EX__BASE=64'       # base value for error messages

readonly 'EX_USAGE=64'       # command line usage error
readonly 'EX_DATAERR=65'     # data format error
readonly 'EX_NOINPUT=66'     # cannot open input
readonly 'EX_NOUSER=67'      # addressee unknown
readonly 'EX_NOHOST=68'      # host name unknown
readonly 'EX_UNAVAILABLE=69' # service unavailable
readonly 'EX_SOFTWARE=70'    # internal software error
readonly 'EX_OSERR=71'       # system error (e.g., can't fork)
readonly 'EX_OSFILE=72'      # critical OS file missing
readonly 'EX_CANTCREAT=73'   # can't create (user) output file
readonly 'EX_IOERR=74'       # input/output error
readonly 'EX_TEMPFAIL=75'    # temp failure; user is invited to retry
readonly 'EX_PROTOCOL=76'    # remote error in protocol
readonly 'EX_NOPERM=77'      # permission denied
readonly 'EX_CONFIG=78'      # configuration error

readonly 'EX__MAX=78'        # maximum listed value

trap 'case "${?}" in 0) end_call;; *) end_call "${EX_SOFTWARE}";; esac' 0 # EXIT
trap 'end_call 129' 1  # SIGHUP
trap 'end_call 130' 2  # SIGINT
trap 'end_call 131' 3  # SIGQUIT
trap 'end_call 143' 15 # SIGTERM

### Function: end_call
##
## 一時ディレクトリを削除しスクリプトを終了する。
##
## Parameters:
##
##   $1 - 終了ステータス。
##
## Returns:
##
##   $1 の終了ステータス。

end_call() {
	trap '' 0 # EXIT
	rm -fr -- ${tmpDir:+"${tmpDir}"}
	exit "${1:-0}"
}

### Function: option_error
##
## エラーメッセージを出力する。
##
## Parameters:
##
##   $1 - エラーメッセージ。
##
## Returns:
##
##   終了コード64。

option_error() {
	printf '%s: %s\n' "${0##*/}" "${1}" >&2
	printf "Try '%s' for more information.\\n" "${0##*/} --help" >&2

	end_call "${EX_USAGE}"
}

### Function: append_array_posix
##
## 配列風文字列に要素を追加する。
##
## Parameters:
##
##   $1 - 結果を代入する変数名。
##   $@ - 追加する要素。

append_array_posix() {
	while [ 2 -le "${#}" ]; do
		__append_array_posix "${1}" "${2}"

		eval "shift 2; set -- '${1}'" '${@+"${@}"}'
	done
}

### Function: __append_array_posix
##
## 配列風文字列に要素を追加する。
##
## Parameters:
##
##   $1 - 結果を代入する変数名。
##   $2 - 追加する要素。

__append_array_posix() {
	set "${1}" "${2-}" ''

	until [ "${2#*\'}" '=' "${2}" ]; do
		set -- "${1}" "${2#*\'}" "${3}${2%%\'*}'\"'\"'"
	done

	eval "${1}=\"\${${1}-}\${${1}:+ }'\${3}\${2}'\""
}

# @getoptions
parser_definition() {
	setup REST abbr:true error:option_error plus:true no:0 help:usage \
		-- 'Usage:' "  ${2##*/} [OPTION]... LANG_TAG FILE" \
		'' 'Options:'

	param :'append_array_posix "curlOptions" "--curl-option" "${OPTARG}"' -c --curl-option var:"NAME[=VALUE]" -- 'curl option'
	flag  curlOptions --no-curl-option init:@no on: no: -- 'reset -c, --curl-option'
	disp  :usage      -h --help        -- 'display this help and exit'
	disp  VERSION     -v --version     -- 'output version information and exit'

	msg -- '' 'Exit Status:' \
		'    0 - successful termination' \
		'    1 - FILE was not updated' \
		'   64 - command line usage error' \
		'   65 - data format error' \
		'   66 - cannot open input' \
		'   67 - addressee unknown' \
		'   68 - host name unknown' \
		'   69 - service unavailable' \
		'   70 - internal software error' \
		"   71 - system error (e.g., can't fork)" \
		'   72 - critical OS file missing' \
		"   73 - can't create (user) output file" \
		'   74 - input/output error' \
		'   75 - temp failure; user is invited to retry' \
		'   76 - remote error in protocol' \
		'   77 - permission denied' \
		'   78 - configuration error' \
		'  129 - received SIGHUP' \
		'  130 - received SIGINT' \
		'  131 - received SIGQUIT' \
		'  143 - received SIGTERM'
}
# @end

# @gengetoptions parser -i parser_definition parse "${1}"
# Generated by getoptions (BEGIN)
# URL: https://github.com/ko1nksm/getoptions (v3.3.0)
curlOptions=''
REST=''
parse() {
  OPTIND=$(($#+1))
  while OPTARG= && [ $# -gt 0 ]; do
    set -- "${1%%\=*}" "${1#*\=}" "$@"
    while [ ${#1} -gt 2 ]; do
      case $1 in (*[!a-zA-Z0-9_-]*) break; esac
      case '--curl-option' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --curl-option"
      esac
      case '--no-curl-option' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --no-curl-option"
      esac
      case '--help' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --help"
      esac
      case '--version' in
        "$1") OPTARG=; break ;;
        $1*) OPTARG="$OPTARG --version"
      esac
      break
    done
    case ${OPTARG# } in
      *\ *)
        eval "set -- $OPTARG $1 $OPTARG"
        OPTIND=$((($#+1)/2)) OPTARG=$1; shift
        while [ $# -gt "$OPTIND" ]; do OPTARG="$OPTARG, $1"; shift; done
        set "Ambiguous option: $1 (could be $OPTARG)" ambiguous "$@"
        option_error "$@" >&2 || exit $?
        echo "$1" >&2
        exit 1 ;;
      ?*)
        [ "$2" = "$3" ] || OPTARG="$OPTARG=$2"
        shift 3; eval 'set -- "${OPTARG# }"' ${1+'"$@"'}; OPTARG= ;;
      *) shift 2
    esac
    case $1 in
      --?*=*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%%\=*}" "${OPTARG#*\=}"' ${1+'"$@"'}
        ;;
      --no-*|--without-*) unset OPTARG ;;
      -[c]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" "${OPTARG#??}"' ${1+'"$@"'}
        ;;
      -[hv]?*) OPTARG=$1; shift
        eval 'set -- "${OPTARG%"${OPTARG#??}"}" -"${OPTARG#??}"' ${1+'"$@"'}
        OPTARG= ;;
      +*) unset OPTARG ;;
    esac
    case $1 in
      '-c'|'--curl-option')
        [ $# -le 1 ] && set "required" "$1" && break
        OPTARG=$2
        append_array_posix "curlOptions" "--curl-option" "${OPTARG}"
        shift ;;
      '--no-curl-option')
        [ "${OPTARG:-}" ] && OPTARG=${OPTARG#*\=} && set "noarg" "$1" && break
        eval '[ ${OPTARG+x} ] &&:' && OPTARG='' || OPTARG=''
        curlOptions="$OPTARG"
        ;;
      '-h'|'--help')
        usage
        exit 0 ;;
      '-v'|'--version')
        echo "${VERSION}"
        exit 0 ;;
      --)
        shift
        while [ $# -gt 0 ]; do
          REST="${REST} \"\${$(($OPTIND-$#))}\""
          shift
        done
        break ;;
      [-+]?*) set "unknown" "$1"; break ;;
      *)
        REST="${REST} \"\${$(($OPTIND-$#))}\""
    esac
    shift
  done
  [ $# -eq 0 ] && { OPTIND=1; unset OPTARG; return 0; }
  case $1 in
    unknown) set "Unrecognized option: $2" "$@" ;;
    noarg) set "Does not allow an argument: $2" "$@" ;;
    required) set "Requires an argument: $2" "$@" ;;
    pattern:*) set "Does not match the pattern (${1#*:}): $2" "$@" ;;
    notcmd) set "Not a command: $2" "$@" ;;
    *) set "Validation error ($1): $2" "$@"
  esac
  option_error "$@" >&2 || exit $?
  echo "$1" >&2
  exit 1
}
usage() {
cat<<'GETOPTIONSHERE'
Usage:
  cupra-lo-jbovlaste-vreji.sh [OPTION]... LANG_TAG FILE

Options:
  -c,     --curl-option NAME[=VALUE] 
                              curl option
          --no-curl-option    reset -c, --curl-option
  -h,     --help              display this help and exit
  -v,     --version           output version information and exit

Exit Status:
    0 - successful termination
    1 - FILE was not updated
   64 - command line usage error
   65 - data format error
   66 - cannot open input
   67 - addressee unknown
   68 - host name unknown
   69 - service unavailable
   70 - internal software error
   71 - system error (e.g., can't fork)
   72 - critical OS file missing
   73 - can't create (user) output file
   74 - input/output error
   75 - temp failure; user is invited to retry
   76 - remote error in protocol
   77 - permission denied
   78 - configuration error
  129 - received SIGHUP
  130 - received SIGINT
  131 - received SIGQUIT
  143 - received SIGTERM
GETOPTIONSHERE
}
# Generated by getoptions (END)
# @end

parse ${@+"${@}"}
eval "set -- ${REST}"

case "${#}" in
	'0')
		printf '%s: Requires an argument: LANG_TAG and FILE\n' "${0##*/}" >&2
		printf "Try '%s' for more information.\\n" "${0##*/} --help" >&2

		end_call "${EX_USAGE}"
		;;
	'1')
		printf '%s: Requires an argument: FILE\n' "${0##*/}" >&2
		printf "Try '%s' for more information.\\n" "${0##*/} --help" >&2

		end_call "${EX_USAGE}"
		;;
esac

lang="${1}"
currentFile="${2}"
tmpDir=$(mktemp -d)
downloadFile="${tmpDir}/data"
command='cpacu-lo-jbovlaste-datni.sh'

if ! command -v "${command}" >'/dev/null'; then
	current="$(dirname "${0}")/${command}"

	if [ -f "${current}" ] && [ -x "${current}" ]; then
		command="${current}"
	else
		printf "%s: '%s' not found.\\n" "${0##*/}" "${command}" >&2
		printf "Try '%s' for more information.\\n" "${0##*/} --help" >&2

		end_call "${EX_UNAVAILABLE}"
	fi
fi

if ! [ -e "${currentFile}" ]; then
	currentFileDir=$(dirname -- "${currentFile}"; printf '_')
	mkdir -p -- "${currentFileDir%?_}"

	: >"${currentFile}"
elif ! [ -f "${currentFile}" ]; then
	printf "%s: '%s' is not a regular file.\\n" "${0##*/}" "${currentFile}" >&2
	printf "Try '%s' for more information.\\n" "${0##*/} --help" >&2

	end_call "${EX_DATAERR}"
fi

LC_ALL="${LC_ALL_ORG}" eval '"${command}"' "${curlOptions}" '"${lang}"' >"${downloadFile}" || end_call "${?}"

xmllint --noout "${downloadFile}"

diff -- "${downloadFile}" "${currentFile}" >'/dev/null' || case "${?}" in
	'1')
		cat -- "${downloadFile}" >"${currentFile}"

		exit
		;;
	*) end_call "${EX_SOFTWARE}";;
esac

end_call '1'
