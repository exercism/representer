#!/bin/bash

set -o errexit
set -o nounset
FATAL=-1
OK=0
program=`basename $0`
three="Pling"
five="Plang"
seven="Plong"
string=""
if [ $# -ne 1 ]; then 
	echo "Usage: $program <number>"
	exit $FATAL
fi

if (( $1 % 3 == 0 )); then 
	string="$three"
fi

if (( $1 % 5 == 0 )); then 
	string="$string$five"
fi	

if (( $1 % 7 == 0 )); then 
	string="$string$seven"
fi

if [ -z "$string" ]; then
	string=$1
fi

echo "$string"
