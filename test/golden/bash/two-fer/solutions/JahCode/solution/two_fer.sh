#!/bin/bash -e

main() {
  (( $# == 0 )) && name="you" || name="$1"
  echo "One for $name, one for me."
  return
}

main "$@"
exit 0
