#!/usr/bin/env bash
main () {
        declare -A weekday=( ["Sunday"]=0 ["Monday"]=1  ["Tuesday"]=2  ["Wednesday"]=3 ["Thursday"]=4  ["Friday"]=5  ["Saturday"]=6 )
        year=$1;         month=$2;         schedule=$3;        dow=$4
        firstDay=$(date -d "$1/$2/1" +%w)   # 0 is Sunday
        downum=${weekday[$dow]}
        (( dow_offset = ( downum - firstDay + 7) % 7 ))
        (( firstDOW = dow_offset + 1 )) 
        (( month == 12 )) && daysInTheMonth=31 ||  (( daysInTheMonth=1$(date -d "$1/$(($2+1))/1" +%j) - 1$(date -d "$1/$2/1" +%j) ))
        daysofweeks=(0)
        for (( ii= $firstDOW; ii<=$daysInTheMonth; ii += 7)); do 
            daysofweeks+=($ii)
            ((ii>=13 && ii<=19)) && teenth=$ii
            theLastDay=$ii
        done
        case $schedule in
            teenth) day=$teenth;;
            first) day=${daysofweeks[1]};;
            second) day=${daysofweeks[2]};;
            third) day=${daysofweeks[3]};;
            fourth) day=${daysofweeks[4]};;
            last) day=$theLastDay;;
        esac
        [[ -z $day ]] && { echo "invalid argument"; exit 1; }
        echo $(date -d "$year/$month/$day" +"%Y-%m-%d")
  }
  main "$@"