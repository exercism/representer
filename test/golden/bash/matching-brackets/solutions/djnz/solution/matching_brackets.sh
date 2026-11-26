#!/usr/bin/env bash

#
# matching-brackets: check is a string has correctly matched (,[,{s
#
# idea: remove all non-brackets, then trim pairs from what is left
#   so: if we keep peeling them from the inside we should clear them all
#  but: if we find an empty string that contains not (), [], nor {}
# then: we have a bad pattern
# note: this is a job for a recursive parser but this method works
#   by: djnz on exercism (bruce molay)
# date: 2019-12-30 20:38
# note: gnu grep should use BREs for its syntax so we do not need to
#	escape ( and {.  It seems to be the case.
#
main () 
{
	S=$(echo "$1" | tr -dc '{}()[]')
	while test ! -z "$S"
	do
		if echo "$S" | grep "()" > /dev/null
		then
			S=$(echo "$S" | sed 's/()//g')
		elif echo "$S" | grep "\[\]" > /dev/null
		then
			S=$(echo "$S" | sed 's/\[\]//g')
		elif echo "$S" | grep "{}" > /dev/null
		then
			S=$(echo "$S" | sed 's/{}//g')
		else
			echo false
			exit 0
		fi
	done
	echo true
	exit 0
}
#
main "$@"
#
