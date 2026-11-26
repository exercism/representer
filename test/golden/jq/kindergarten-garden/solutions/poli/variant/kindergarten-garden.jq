{ "G": "grass", "C": "clover", "R": "radishes", "V": "violets" } as $plant
| (.diagram | split("\n") | first | split("")) as $d1
| (.diagram | split("\n") | last | split("")) as $d2
| ("A" | explode | first) as $a 
| (.student | explode | first - $a | . * 2 ) as $i
| [ $plant[$d1[$i]], $plant[$d1[$i+1]], $plant[$d2[$i]], $plant[$d2[$i-1]] ]