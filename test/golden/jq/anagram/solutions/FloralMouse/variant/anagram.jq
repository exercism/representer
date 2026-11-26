(.subject | ascii_upcase) as $s |
.candidates |
map(select(
	ascii_upcase | (
		. != $s and ([., $s | split("") | sort] | .[1] == .[1])
	)
))
