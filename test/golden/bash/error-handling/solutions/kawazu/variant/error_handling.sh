#!/usr/bin/env bash

if [ $# == 1 ]
then
    echo "Hemlo, $1"
    exit 0
fi

echo 'Usage: error_handling.sh <person>'
exit 1