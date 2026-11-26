package grade_school

import "core:slice"

School :: struct {
	students: map[string]struct{},
	grades:   [10][dynamic]string,
}

Grade :: struct {
	id:       u8,
	students: []string,
}

// Add a student's name to the roster for a grade.
add :: proc(s: ^School, student: string, grade_id: u8) -> bool {
	if int(grade_id) >= len(s.grades) do return false
	if student in s.students do return false
	s.students[student] = {}

	i, _ := slice.binary_search(s.grades[grade_id][:], student)
	inject_at(&s.grades[grade_id], i, student)
	return true
}

grade :: proc(s: ^School, grade_id: u8) -> []string {
	if int(grade_id) >= len(s.grades) do return nil
	return s.grades[grade_id][:]
}

roster :: proc(s: ^School) -> []Grade {
	// Count number of grades with at least one student.
	count := 0
	for &students in s.grades do if len(students) > 0 do count += 1
	if count == 0 do return nil

	out := make([]Grade, count)
	i := 0
	for &students, grade_id in s.grades {
		if len(students) == 0 do continue
		out[i] = Grade{u8(grade_id), students[:]}
		i += 1
	}
	return out
}

delete_school :: proc(s: ^School) {
	delete(s.students)
	for &students in s.grades do delete(students)
}
