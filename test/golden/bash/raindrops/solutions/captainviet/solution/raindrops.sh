#!/usr/bin/env bash

case $(( $1 % 3 )) in
	0)
		pling="Pling"
		;;
	*)
		pling=""
		;;
esac

case $(( $1 % 5 )) in
	0)
		plang="Plang"
		;;
	*)
		plang=""
		;;
esac

case $(( $1 % 7 )) in
	0)
		plong="Plong"
		;;
	*)
		plong=""
		;;
esac
string="$pling$plang$plong"
case $string in
	'')
		echo "$1"
		;;
	*)
		echo "$string"
		;;
esac
