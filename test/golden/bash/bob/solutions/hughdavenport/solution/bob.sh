#!/usr/bin/env bash

request=$1
while [[ "${request:${#request}-1}" =~ [$'\n\r \t'] ]]; do
	request="${request:0:${#request}-1}"
done
if [ ${#request} -eq 0 ]; then
	echo "Fine. Be that way!"
elif [ "${request:${#request}-1}" == "?" ]; then
	if [ "${request,,}" != "$request" ] && [ "${request^^}" == "$request" ]; then
		echo "Calm down, I know what I'm doing!"
	else
		echo "Sure."
	fi
elif [ "${request,,}" != "$request" ] && [ "${request^^}" == "$request" ]; then
	echo "Whoa, chill out!"
else
	echo "Whatever."
fi
