#!/usr/bin/env bash

# Synopsis:
# Run Inspector on a request using the Docker image, which mimics how
# it runs in production (as a Lambda function).

# Arguments:
# $1: path to a request.json file, holding the request's JSON body
# $2: path to output directory (optional)

# Output:
# Prints the response. If the output directory is specified, also writes the
# response's body to response.json in that directory.

# Example:
# ./bin/run-in-docker.sh test/fixtures/requests/ruby/two-fer/request.json

# Stop executing when a command returns a non-zero return code
set -e

if [[ $# -lt 1 ]]; then
    echo "usage: ./bin/run-in-docker.sh path/to/request.json [path/to/output/directory/]"
    exit 1
fi

container_port=9876

# Build the Docker image, unless SKIP_BUILD is set
if [[ -z "${SKIP_BUILD}" ]]; then
    docker build --rm -t exercism/inspector .
fi

container_id=$(docker run --detach --publish ${container_port}:8080 exercism/inspector)

# Give the Lambda runtime a moment to start
sleep 1

event_json=$(jq -n --rawfile b "${1}" '{body: $b}')
response=$(curl -s -XPOST http://localhost:${container_port}/2015-03-31/functions/function/invocations -d "${event_json}")
echo "${response}"

if [ -n "${2}" ]; then
    echo "${response}" | jq '.body | fromjson' > "${2%/}/response.json"
fi

docker stop "${container_id}" > /dev/null
