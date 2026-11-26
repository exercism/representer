#!/usr/bin/env bash
# Uncomment for debugging
#set -x

dna_sequence=$1
nuc_a=0
nuc_c=0
nuc_g=0
nuc_t=0

[[ $dna_sequence =~ [^ACGT] ]] && { echo "Invalid nucleotide in strand" ; exit 1 ; }

for (( i=0; i<=${#dna_sequence}; i++ )); do
    case ${dna_sequence:i:1} in
        a|A) (( ++nuc_a )) ;;
        c|C) (( ++nuc_c )) ;;
        g|G) (( ++nuc_g )) ;;
        t|T) (( ++nuc_t )) ;;
    esac
done

printf '%s\n%s\n%s\n%s\n' "A: ${nuc_a}" "C: ${nuc_c}" "G: ${nuc_g}" "T: ${nuc_t}"