proc rotate {text shift} {
    set table [dict create]
	set alphabet [split {abcdefghijklmnopqrstuvwxyz} {}]
	set rotaplha [concat  [lrange $alphabet end-[expr {$shift-1}] end] \
		[lrange $alphabet 0 end-$shift]]
	foreach k $rotaplha v $alphabet {
		dict set table $k $v
		dict set table [string toupper $k] [string toupper $v]
	}
	string map $table $text
}
