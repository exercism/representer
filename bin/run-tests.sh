#!/usr/bin/env bash

# Synopsis:
# Test the representer: run the unit tests, then run the representer against
# each request in tests/ and compare its response with the expected one.

# Arguments:
# $1: track slug (optional, limits the golden tests to that track)

# Output:
# The unit test results, and the diff of any golden test whose response
# doesn't match expected_response.json.

# Example:
# ./bin/run-tests.sh
# ./bin/run-tests.sh ruby

# Stop executing when a command returns a non-zero return code
set -e

track_slug="${1:-*}"
exit_code=0

bundle exec rake test

for test_dir in tests/${track_slug}/*/; do
    test_dir="${test_dir%/}"
    response_file="${test_dir}/response.json"
    expected_response_file="${test_dir}/expected_response.json"

    bin/run.sh "${test_dir}/request.json" "${test_dir}" > /dev/null

    echo "${test_dir}: comparing response.json to expected_response.json"
    if ! diff <(jq -S . "${response_file}") <(jq -S . "${expected_response_file}"); then
        exit_code=1
    fi
done

exit ${exit_code}
