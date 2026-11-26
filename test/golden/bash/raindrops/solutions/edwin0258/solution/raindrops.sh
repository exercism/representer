#!/usr/bin/env bash
text=""
! (( $1 % 3 )) && text="Pling"
! (( $1 % 5 )) && text=$text"Plang"
! (( $1 % 7 )) && text=$text"Plong"
! [[ $text ]] && echo $1 || echo $text