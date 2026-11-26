#!/usr/bin/env bash

main () {
        num="$1"
        string=""
	dividers=()
	end=$(($num/2))
	if (($num % 2 == 0))
	then
		end=$(($end+1))
	fi
	for (( i=1; i<=$end;i++))
	do
		if (( $num % $i == 0 ))
		then
			dividers+=($i)
		fi
	done
	dividers+=($num)
	for ((i=0; i<${#dividers[@]}; i++))
	do
		curDiv=${dividers[$i]}
#		echo $curDiv
	        if (( $curDiv == 3 ))
        	then
	                string=$(echo "${string}Pling")
	        elif (( $curDiv == 5 ))
	        then
	                string=$(echo "${string}Plang")
	        elif (( $curDiv == 7 ))
	        then
	                string=$(echo "${string}Plong")
	        fi
	done
	if [ $(echo -n $string | wc -c) -gt "0" ]
	then
	        echo "$string"
	else
		echo "$num"
	fi
}

main "$@"



