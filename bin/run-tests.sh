#!/usr/bin/env bash

# Synopsis:
# Test Inspector: run the unit tests, then run Inspector against
# each request in test/fixtures/requests/ and compare its response with the
# expected one.
# With a track slug, run only that track's tests: its language tests, its
# golden tests, its fuzz test and its request tests.

# Arguments:
# $1: track slug (optional, limits every test to that track)

# Output:
# The unit test results, and the diff of any request test whose response
# doesn't match expected_response.json.

# Example:
# ./bin/run-tests.sh
# ./bin/run-tests.sh ruby

# Stop executing when a command returns a non-zero return code
set -e

track_slug="${1:-*}"
exit_code=0

if [ -z "${1:-}" ]; then
    bundle exec rake test
else
    # Test names and files use underscores where track slugs use hyphens.
    name="${1//-/_}"
    language_tests=$(ls "test/languages/${name}_test.rb" test/languages/"${name}"/*_test.rb 2>/dev/null || true)
    for test_file in ${language_tests}; do
        bundle exec ruby -Itest "${test_file}"
    done
    bundle exec ruby -Itest test/golden_test.rb -n "/\Atest_${name}_/"
    FUZZ_TRACKS="$1" bundle exec ruby -Itest test/fuzz_test.rb
fi

for test_dir in test/fixtures/requests/${track_slug}/*/; do
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
