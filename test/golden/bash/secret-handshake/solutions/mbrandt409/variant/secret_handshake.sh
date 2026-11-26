#!/usr/bin/env bash
main () {
D2B=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
var=${D2B[$1]}
ret=""
if [[ ${var::-4} != *1 ]]
then
    [[ $var = *"1" ]] && ret+="wiok,"
    [[ ${var::-1} = *1 ]] && ret+="double blink,"
    [[ ${var::-2} = *1 ]] && ret+="close your eyes,"
    [[ ${var::-3} = *1 ]] && ret+="jump,"
else
    [[ ${var::-3} = *1 ]] && ret+="jump,"
    [[ ${var::-2} = *1 ]] && ret+="close your eyes,"
    [[ ${var::-1} = *1 ]] && ret+="double blink,"
    [[ $var = *"1" ]] && ret+="wink,"
fi
[[ -n $ret ]] && echo ${ret::-1}
[[ -z $ret ]] && echo $ret
exit 0
}
main "$@"
