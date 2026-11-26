#!/usr/bin/env bash

isbn="$@"

# strip spaces and dashes
isbn="${isbn// /}"
isbn=${isbn//-/}

if ! [[ "$isbn" =~ ^[0-9]{9}[0-9xX]$ ]] ; then
	echo "false"
	exit 0
fi

sum=0
counter=10
for (( i=0 ; i < ${#isbn} ; i++ )) ; do
	if [ $counter -eq 1 ] && [[ ${isbn:i:1} =~ [xX] ]] ; then
		(( sum += 10 ))
	else
		(( sum += ${isbn:i:1} * counter ))
	fi

	(( counter -= 1 ))
done

if (( sum % 11 == 0 )) ; then
	echo "true"
else
	echo "false"
fi
