class GradeSchool {
    // Write your code for the 'GradeSchool' exercise in this file.
    
    private var _roster: [Int : Set<String>] = [:]

    func addStudent(_ name: String, grade: Int) -> Bool {
        guard !roster().contains(name) else { return true }
        
        if var existing = _roster[grade] { 
            let inserted = existing.insert(name)
            _roster[grade] = existing

            return inserted.inserted
        } 
        _roster[grade] = Set([name])
        return true
    }
    
    func roster() -> [String] {
        _roster.keys.sorted().flatMap({ Array(_roster[$0] ?? []).sorted() })
    }

    func studentsInGrade(_ grade: Int) -> [String] { 
        return Array(_roster[grade] ?? []).sorted()                     
    }
}
