#!/usr/bin/env bash

# 1. Split the sentence with ' ' and '-'.
# 2. Remove any punctuation marks & see if its not empty
# 3. Get the beggining letter of the word
# 4. Append to a running var
# 5. Profit!

acronym=""
IFS=" -" read -ra words <<< "$1"
for word in "${words[@]}"; do
    word=$(echo "$word" | tr '-d' '[:punct:]')
    if [[ -z "$word" ]]; then
        continue
    fi
    acronym+=${word:0:1}
done

echo "${acronym^^}"

