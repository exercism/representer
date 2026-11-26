#!/bin/awk -f
# # # # # # #
# input - name, number

{
	sfx="th"
	if($2 !~ /1.$/)
		switch($2)
		{
			case /1$/: sfx="st"; break
			case /2$/: sfx="nd"; break
			case /4$/: sfx="rd"; break
		}
	print $1 ", you are the " $2 sfx " customer we serve today. Thank you!"
}