class GradeSchool {
    var students = [String: Int]()
    func roster() -> [String] {
        var sortedStudents = Array(students)
        sortedStudents.sort {
            if $0.value != $1.value {
                return $0.value < $1.value
            } else {
                return $0.key < $1.key
            }
        }
        var result: [String] = []
        for (name, _) in sortedStudents {
            result.append(name)
        }
        return result
    }
    func addStudent(_ name: String, grade: Int) -> Bool {
        // Don't add the student if already added (same grade or different grade)
        if let existing = students[name] {
            return false  // true only if same grade
        }
        students[name] = grade
        return true
    }
    func studentsInGrade(_ student: Int) -> [String] {
        var names: [String] = []
        for (name, grade) in students {
            if grade == student {
                names.append(name)
            }
        }
        return names.sorted()
    }
}
