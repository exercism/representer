#!/usr/bin/env bash
input="${1}"
function checks {
  if [ "${#input}" == "0" ]; then
    printf 'A: 0\nC: 0\nG: 0\nT: 0'
    exit
  fi

  stripped_input="${input//A/''}"
  stripped_input="${stripped_input//C/''}"
  stripped_input="${stripped_input//G/''}"
  stripped_input="${stripped_input//T/''}"
  if [[ ${#stripped_input} -gt 0 ]]; then
      echo "Invalid nucleotide in strand"
      exit 10
  fi
}

function count {
a_count="${input//[^A,]}"
c_count="${input//[^C,]}"
g_count="${input//[^G,]}"
t_count="${input//[^T,]}"
printf "A: ${#a_count}\nC: ${#c_count}\nG: ${#g_count}\nT: ${#t_count}"
}

checks
count