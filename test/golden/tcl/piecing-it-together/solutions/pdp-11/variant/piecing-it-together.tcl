proc dictAdd {tabName args} {
	upvar $tabName tab
	if {![dict exists $tab {*}[lrange $args 0 end-1]]} {
		dict set tab {*}$args
	}
}

proc isComplete {tab} {
	expr {[dict exists $tab rows] && [dict exists $tab columns]}
}

proc isLegal {tab} {
	expr {1.0 * [dict get $tab columns] / [dict get $tab rows] == [dict get $tab aspectRatio]}
}

proc completeRest {tabName} {
	upvar $tabName tab
	set rows [dict get $tab rows]
	set columns [dict get $tab columns]
	dictAdd tab pieces [expr {$rows * $columns}]
	dictAdd tab border [expr {2 * ($rows + $columns - 2)}]
	dictAdd tab inside [expr {[dict get $tab pieces] - [dict get $tab border]}]
	set aspectRatio [expr {1.0 * $columns / $rows}]
	dictAdd tab aspectRatio $aspectRatio
	dictAdd tab format [expr {$aspectRatio > 1 ? "landtcape" : $aspectRatio < 1 ? "portrait" : "square"}]
}

proc jigsawData {tab} {
	if {[dict exists $tab format] && [dict get $tab format] == "square"} {
		dict set tab aspectRatio 1.0
	}
	set cycleCount 1
	while {$cycleCount <= 5 && ![isComplete $tab]} {
		if {[dict exists $tab aspectRatio]} {
			set aspectRatio [dict get $tab aspectRatio]
			if {[dict exists $tab pieces]} {
				dictAdd tab rows [expr {
					isqrt([dict get $tab pieces] / $aspectRatio)
				}]
			}
			if {[dict exists $tab border]} {
				set border [dict get $tab border]
				dictAdd tab rows [expr {
					round(($border + 4) / (2 * (1 + $aspectRatio)))
				}]
			}
			if {[dict exists $tab inside]} {
				set inside [dict get $tab inside]
				dictAdd tab rows [expr {
					round(
					1 + 1 / $aspectRatio *
					(1 + sqrt(pow($aspectRatio-1, 2) + $aspectRatio * $inside))
					)
				}]
			}
			if {[dict exists $tab columns]} {
				dict set tab rows [expr {
					round([dict get $tab columns] / $aspectRatio)
				}]
			} elseif {[dict exists $tab rows]} {
				dict set tab columns [expr {
					round([dict get $tab rows] * $aspectRatio)
				}]
			}
		}
		if {[dict exists $tab pieces]} {
			set pieces [dict get $tab pieces]
			if {[dict exists $tab inside]} {
				dict set tab border [expr {$pieces + [dict get $tab inside]}]
			}
			if {[dict exists $tab border]} {
				if {[dict exists $tab format]} {
					set border [dict get $tab border]
					set deltaSqrt \
						[expr {isqrt(pow($border + 4, 2) - 16 * $pieces)}]
					set solutions [list \
						[expr {round(($border - $deltaSqrt) / 4.0) + 1}] \
						[expr {round(($border + $deltaSqrt) / 4.0) + 1}]
					]
					if {[dict get $tab format] == "landscape"} {
						lassign $solutions rows columns 
					} else {
						lassign $solutions columns rows
					}
				}
				dictAdd tab rows $rows
				dictAdd tab columns $columns
			} 
			if {[dict exists $tab columns]} {
				dictAdd tab rows [expr {$pieces / [dict get $tab columns]}]
			} elseif {[dict exists $tab rows]} {
				dict set tab columns [expr {$pieces / [dict get $tab rows]}]
			}
		}
		if {[dict exists $tab border]} {
			set border [dict get $tab border]
			if {[dict exists $tab inside]} {
				dict set tab pieces \
					[expr {[dict get $tab border] + [dict get $tab inside]}]
			}
			if {[dict exists $tab rows]} {
				dictAdd tab columns \
					[expr {$border / 2 + 2 - [dict get $tab rows]}]
			} elseif {[dict exists $tab columns]} {
				dict set tab rows \
					[expr {$border / 2 + 2 - [dict get $tab columns]}]
			}
		}
		if {[dict exists $tab inside]} {
			set inside [dict get $tab inside]
			if {[dict exists $tab rows]} {
				set rows [dict get $tab rows]
				dict set tab columns \
					[expr {($inside + 2 * $rows - 4) / ($rows - 2)}]
			} elseif {[dict exists $tab columns]} {
				set columns [dict get $tab columns]
				dict set tab rows \
					[expr {($inside + 2 * $columns - 4) / ($columns - 2)}]
			}
		}
		incr cycleCount
	}
	if {$cycleCount > 5}  {error "Insufficient data"}
	completeRest tab
	if {![isLegal $tab]} {error "Contradictory data"}
	return $tab
}
