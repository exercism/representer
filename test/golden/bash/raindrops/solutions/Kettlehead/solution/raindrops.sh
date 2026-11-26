#!/usr/bin/env bash

# This option will make the script exit when there is an error
set -o errexit
# This option will make the script exit when it tries to use an unset variable
set -o nounset

if (($1%3==0)); then
  output=Pling
fi
if (($1%5==0)); then
  output=${output:-""}Plang
fi
if (($1%7==0)); then
  output=${output:-""}Plong
fi
echo "${output:-$1}"