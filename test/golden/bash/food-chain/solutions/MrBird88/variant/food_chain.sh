#!/usr/bin/env bash

if (($# != 2)); then
  >&2 echo "2 arguments expected"
  exit 1
fi

if (($1 > $2)); then
  >&2 echo "Start must be less than or equal to End"
  exit 1
fi

lines=(
  "fly" "I don't know why she swallowed the fly. Perhaps she'll die."
  "spider" "It wriggled and jiggled and tickled inside her."
  "bird" "How absurd to swallow a bird!"
  "cat" "Imagine that, to swallow a cat!"
  "dog" "What a hog, to swallow a dog!"
  "goat" "Just opened her throat and swallowed a goat!"
  "cow" "I don't know how she swallowed a cow!"
  "horse" "She's dead, of course!"
)

name() {
  echo "${lines[$((($1 - 1) * 2))]}"
}

action() {
  echo "${lines[$((($1 + 1) * 2 + 1))]}"
}

first_line() {
  echo "I know an old lady who swallowed a $(name "$1")."
}

to_catch() {
  line="to catch the $(name "$1")"
  (($1 == 2)) && line+=" that wriggled and jiggled and tickled inside her." || line+="."
  echo "$line"
}

refrain() {
  echo "She swallowed the $(name "$1") $(to_catch $(($1 - 1)))"
}

make_verse() {
  first_line "$1"
  if (($1 == 8)); then
    action "$1"
  else
    action "$1"
    for ((j = $1; j > 1; j--)); do
      refrain "$j"
    done
    (($1 != 1)) && action 1
  fi
}

for ((i = $1; i <= $2; i++)); do
  make_verse "$i"
  echo
done
