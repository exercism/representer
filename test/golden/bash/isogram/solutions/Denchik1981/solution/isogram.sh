

#s='Lumb-erja, %ckSa'
 s=$1

s=$(echo "$s" |tr [:upper:] [:lower:] | sed -r 's/[^a-z]//g') 

#echo "$s"

sa=$( echo  "$s" | egrep -o . | sort -u | tr -d  [:space:]) 

#echo "$sa"

if ((${#s}  == ${#sa})) ;then
  echo "true"
else
  echo "false"
fi


