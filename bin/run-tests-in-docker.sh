#!/usr/bin/env bash

# Synopsis:
# Test the representer's Docker image by running it against each request in
# test/fixtures/requests/ and comparing its response with the expected one.
# The Docker image is built automatically.

# Arguments:
# $1: track slug (optional, limits the tests to that track)

# Output:
# The diff of any test whose response doesn't match expected_response.json.

# Example:
# ./bin/run-tests-in-docker.sh

# Stop executing when a command returns a non-zero return code
set -e

track_slug="${1:-*}"
exit_code=0

# Pre-build the image, so that it isn't built for every test
docker build --rm -t exercism/representer .

for test_dir in test/fixtures/requests/${track_slug}/*/; do
    test_dir="${test_dir%/}"
    response_file="${test_dir}/response.json"
    expected_response_file="${test_dir}/expected_response.json"

    SKIP_BUILD=1 bin/run-in-docker.sh "${test_dir}/request.json" "${test_dir}" > /dev/null

    echo "${test_dir}: comparing response.json to expected_response.json"
    if ! diff <(jq -S . "${response_file}") <(jq -S . "${expected_response_file}"); then
        exit_code=1
    fi
done

exit ${exit_code}
