sound_of_rain=''

if [[ 0 == $(($1 % 3)) ]]; then
  sound_of_rain=${sound_of_rain}Pling
fi

if [[ 0 == $(($1 % 5)) ]]; then
  sound_of_rain=${sound_of_rain}Plang
fi

if [[ 0 == $(bc <<< "$1 % 7") ]]; then
  sound_of_rain=${sound_of_rain}Plong
fi

if [[ -z $sound_of_rain ]]; then
  sound_of_rain=$1
fi

echo $sound_of_rain
exit 0