package robotname

import "core:fmt"
import "core:math/rand"
import "core:strings"

MAX_ROBOTS :: 26 * 26 * 10 * 10 * 10

Robot_Storage :: struct {
	free_list: [dynamic]uint,
	robots: map[uint]Robot,
}

Robot :: struct {
	id: uint,
	name: string,
}

Error :: enum {
	None,
	Could_Not_Create_Name,
	Unimplemented,
}

make_storage :: proc() -> Robot_Storage {
	storage := Robot_Storage {}

	for i in 0..<MAX_ROBOTS {
		append(&storage.free_list, uint(i))
	}
	rand.shuffle(storage.free_list[:])
	return storage
}

delete_storage :: proc(storage: ^Robot_Storage) {
	for _, v in storage.robots {
		delete(v.name)
	}
	delete(storage.free_list)
	delete(storage.robots)
}

name_from_id :: proc(id: uint) -> string {
	id := id
	num := id % 1000
	letter_2 := rune('A' + id / 1000 % 26)
	letter_1 := rune('A' + id * 1000 / 26 % 26)
	return fmt.aprintf("{}{}%3i", letter_1, letter_2, num)
}


new_robot :: proc(storage: ^Robot_Storage) -> (Robot, Error) {
	if len(storage.free_list) == 0 do return Robot{}, .Could_Not_Create_Name
	id := pop(&storage.free_list)

	storage.robots[id] = Robot {
		id = id,
		name = name_from_id(id)
	}

	return storage.robots[id], .None
}

reset :: proc(storage: ^Robot_Storage, r: ^Robot) {
	old := r.id
	inject_at(&storage.free_list, 0, old)
	r.id = pop(&storage.free_list)

	delete(r.name)
	r.name = name_from_id(r.id)

	delete_key(&storage.robots, old)
	storage.robots[r.id] = r^
}

