#!/usr/bin/env bash



main(){

  n=$1

rows=()
row=(1)

for ((i=0; i<n; i++)); do
    line=""
    for ((k=0; k<${#row[@]}; k++)); do
        if ((k>0)); then line+=" "; fi
        line+="${row[k]}"
    done
    rows+=("$line")
    new=(1)
    for ((j=0; j<${#row[@]}-1; j++)); do
        new+=($(( row[j] + row[j+1] )))
    done
    new+=(1)
    row=("${new[@]}")
done

for ((i=0; i<n; i++)); do
    printf "%*s" $(( n - i - 1 )) ""
    printf "%s\n" "${rows[i]}"
done

}
main "$@"
