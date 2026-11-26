module main

import rand

struct Robot {
mut:
	name string
}

fn create_robot_storage() []string {
	return []string{}
}

fn create_name() string {
	return rand.string_from_set('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 2) +
		rand.string_from_set('0123456789', 3)
}

fn create_robot(mut robots []string) Robot {
	mut name := create_name()
	for (name in robots) { name = create_name() }
	robots << name
    return Robot { name }
}

fn (mut r Robot) reset(mut robots []string) {
	name := create_robot(mut robots).name
	robots = robots.filter(it == r.name)
	r.name = name
}
