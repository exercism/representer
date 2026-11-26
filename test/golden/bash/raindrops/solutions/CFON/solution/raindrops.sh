#!/usr/bin/env bash
COUNT=3
while [ $COUNT -le 7 ];do
	let "a=$1%$COUNT"
	if [ $a -eq 0 ];then
		case $COUNT in
			"3")
				FOO="${FOO}Pling";;
			"5")
				FOO="${FOO}Plang";;
			*)
				FOO="${FOO}Plong";;
		esac
	elif [ $COUNT -eq 7 ] && [ -z "${FOO}" ];then
		echo "$1";fi
	let "COUNT+=2";done
echo "${FOO}"
