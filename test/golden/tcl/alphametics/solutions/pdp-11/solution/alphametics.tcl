proc solve {puzzle} {
    # puzzle -> equations for each digit: {char char ... reschar} and nonZeroChars: {leadingChar ...}
	# use backtracking to solve the equation(s).
	# first parse the puzzle string.
	set addends [regexp -inline -all {[A-Z]+} $puzzle]
	set nonZeroChars [lsort -unique [lmap word $addends {string index $word 0}]]
	# reverse words to ease of indexing.
	set addends [lmap word $addends {string reverse $word}]
	lassign [list [lindex $addends end] [lreplace $addends end end]] res addends

	set sols [list [dict create carry 0]]
	for {set i 0; set n [string length $res]} {$i<$n} {incr i} {
		set ads [list]
		foreach addend $addends {
			set ad [string index $addend $i]
			if {$ad ne {}} {lappend ads $ad}
		}
		set rd [string index $res $i]
		foreach ad [concat $ads $rd] {
			if {![dict exists [lindex $sols 0] $ad]} {
				set sols [expandSols $sols $ad nonZeroChars]
			}
		}
		#filter out solutions
		set sols [filterSols $sols $ads $rd]
		# no need to go further if there is no possible solution
		if {$sols eq {}} return {}
	}
	set sols [lmap sol $sols {dict unset sol carry}]
	lindex $sols 0
}

proc initAd {ad nonZeroCharsName} {
	upvar $nonZeroCharsName nonZeroChars
	if {[lsearch -sorted $nonZeroChars $ad] != -1} then {return 1} else {return 0}
}
proc expandSols {oldSols ad nonZeroCharsName} {
	upvar $nonZeroCharsName nonZeroChars
	set d [expr {[lsearch -sorted $nonZeroChars $ad]!=-1?1:0}]
	set newSols [list]
	foreach sol $oldSols {
		# exclude carry for lsearch below.
		set carry [dict get $sol carry]
		dict unset sol carry
		for {set i $d} {$i<10} {incr i} {
			# each char should represent different digit.
			if {[lsearch -integer [dict values $sol] $i]!=-1} then continue
			dict set sol $ad $i
			dict set sol carry $carry
			lappend newSols $sol
		}
	}
	return $newSols
}
proc filterSols {sols ads rd} {
	set newSols [list]
	foreach sol $sols {
		set adSum [expr {[lsum [lmap ad $ads {dict get $sol $ad}]]+[dict get $sol carry]}]
		set rdSum [dict get $sol $rd]
		if {$adSum % 10 == $rdSum} {
			dict set sol carry [expr {$adSum/10}]
			lappend newSols $sol
		}
	}
	return $newSols
}
proc lsum {l} {
	tcl::mathop::+ {*}$l
}
