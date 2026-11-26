BEGIN {
	FS = ""
}

{
	s = ""
	for (i = 1; i <= NF; i++) {
		switch ($i) {
		case "G":
			s = s "C"
			break
		case "C":
			s = s "G"
			break
		case "T":
			s = s "A"
			break
		case "A":
			s = s "U"
			break
		default:
			print "Invalid nucleotide detected."
                        exit 1
		}
	}
	print s
}
