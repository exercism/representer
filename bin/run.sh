#!/usr/bin/env bash

# Synopsis:
# Run the representer on a request.

# Arguments:
# $1: path to a request.json file, holding the request's JSON body. Its
#     "outputs" field lists what to generate (see README.md).
# $2: path to output directory (optional)

# Output:
# Prints the response. If the output directory is specified, also writes the
# response's body to response.json in that directory.

# Example:
# ./bin/run.sh tests/ruby/two-fer/request.json

# Stop executing when a command returns a non-zero return code
set -e

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 1 ]]; then
    echo "usage: ./bin/run.sh path/to/request.json [path/to/output/directory/]"
    exit 1
fi

response=$(bundle exec ruby bin/run.rb "${1}")
echo "${response}"

if [ -n "${2}" ]; then
    echo "${response}" | jq '.body | fromjson' > "${2%/}/response.json"
fi
