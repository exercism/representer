module main

struct School {
mut:
	enrolled map[string]bool
	grades   map[int]&Grade
}

struct Grade {
	level int
mut:
	students []string
}

fn add_student(roster &School, name string, grade int) &School {
	mut new_roster := &School{
		grades: roster.grades
	}
	if name in roster.enrolled {
		return new_roster
	}

	new_roster.enrolled[name] = true
	mut g := new_roster.grades[grade] or {
		new_roster.grades[grade] = &Grade{
			level: grade
			students: [name]
		}
		return new_roster
	}
	g.students << name
	g.students.sort()
	return new_roster
}

fn get_students_in_grade(roster &School, grade int) []string {
	g := roster.grades[grade] or { return [] }
	return g.students
}

fn get_all_students(roster &School) []string {
	mut grades := []&Grade{}
	for _, v in roster.grades {
		grades << v
	}
	grades.sort(a.level < b.level)
	mut result := []string{}
	for g in grades {
		result << g.students
	}
	return result
}

fn create_new_roster() &School {
	return &School{
		grades: map[int]&Grade{}
	}
}
