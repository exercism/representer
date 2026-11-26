package robot_simulator

Heading :: enum {
	North,
	East,
	South,
	West,
}

heading_right :: proc(h: Heading) -> Heading {
    n := (int(h) + 1) % len(Heading)
    return Heading(n)
}

heading_left :: proc(h: Heading) -> Heading {
    n := (int(h) - 1) % len(Heading)
    n = n if n >= 0 else len(Heading) + n
    return Heading(n)
}

advance :: proc(r: ^Robot) {
    switch r.hd {
    case .North:
        r.pos.y += 1
    case .East:
        r.pos.x += 1
    case .South:
        r.pos.y -= 1
    case .West:
        r.pos.x -= 1
    }
}

Position :: struct {
	x: int,
	y: int,
}

Robot :: struct {
	pos: Position,
	hd:  Heading,
}

create_robot :: proc(x, y: int, dir: Heading) -> Robot {
	return Robot{pos = Position{x, y}, hd = dir}
}

follow_commands :: proc(r: ^Robot, cmds: string) {
	for rn in cmds {
        switch rn {
        case 'R':
            r.hd = heading_right(r.hd)
        case 'L':
            r.hd = heading_left(r.hd)
        case 'A':
            advance(r)
        }
    }
}
