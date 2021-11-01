#!/bin/bash
###############################################################################
#
# Varsion    : v0.1 2021/10/29
# Owner      : Kaeruken Inc.
# Project    : Shichifukujin Tools
# Descript   : Get & Desplay Logfile
#
###############################################################################

MAXLINE=1000

#

function printhelp() {
echo " Usage : ${0} [-m <処理制御ファイル>] <ログファイル名>"
echo "     -m 表示行数（デフォルト：${MAXLINE}）"
### エラー終了
}

#
function main() {
OPT=$(getopt -o m: -- "$@")

if [ $? != 0 ] ; then
	printhelp
	exit 101
fi
eval set -- "$OPT"

while true
do
	case "$1" in
	-m)
		MAXLINE=${2}
		MAXLINETMP=$(echo ${MAXLINE} | sed "s/[0-9]*//g")
		if [ "${MAXLINETMP}" != "" ]; then
			echo "ERROR : Illeagale Option (${1})"
			printhelp
			exit 102
		fi
		shift 2
		;;
	--)
		shift
		break
		;;
	*)
		echo "ERROR : Illeagale Arrgument"
		printhelp
		exit 103
		;;
	esac
done

#




logfile0=${1}
logfile1=$(ls -1 ${1}* | head -2 | tail -1)
logfilenm=${logfile0##*/}

if [ ! -f "${logfile0}" ]; then
	echo "ERROR : Not Found ${logfile0}"
	printhelp
	exit 104
fi

wc0=$(wc -l ${logfile0} | cut -d" " -f1)
if [ ${wc0} -lt ${MAXLINE} ] && [ "$logfile1}" != "" ]; then
	if [ -f "${logfile1}" ]; then
		wc1=$(( ${MAXLINE} - ${wc0} ))

		logattr=$(echo ${logfile1##*.} | grep -v ${logfilenm})

		case ${logattr} in
		"gz")
			zcat ${logfile1} | tail  -${wc1}
			;;
		*)
			cat ${logfile1}  | tail -${wc1}
			;;
		esac
	fi
else
	wc0=${MAXLINE}
fi

tail -${wc0} ${logfile0}
}

#
main ${*}

#
