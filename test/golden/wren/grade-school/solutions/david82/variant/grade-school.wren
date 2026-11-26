class StringComparator {
  static sort(list) { list.sort {|first, second| lessThanOrEqual(first, second)} }
  // `lt`, `le`, `gt`, `ge` -- borrowed from Perl
  static lessThan(firstString, secondString) {
    var firstCodePoints = firstString.codePoints
    var secondCodePoints = secondString.codePoints
    var firstCount = firstCodePoints.count
    var secondCount = secondCodePoints.count
    var minLength = firstCount <= secondCount ? firstCount : secondCount
    
    for (index in 0...minLength) {
      if (firstCodePoints[index] != secondCodePoints[index]) return firstCodePoints[index] < secondCodePoints[index]
    }
    
    return firstCount < secondCount
  }
  
  static lessThanOrEqual(first, second) { first == second || lessThan(first, second) }
  static greaterThan(first, second) { !lessThanOrEqual(first, second) }
  static greaterThanOrEqual(first, second) { !lessThan(first, second) }
}

class GradeSchool {
  construct new() {
    _roster = {}
  }
  
  roster { grades.reduce([]) {|accumulated, grade| accumulated + _roster[grade]} }
  grades { _roster.keys.toList.sort() }
  // returns a copy, not a reference
  grade(grade) { (_roster[grade] || [])[0..-1] }
  addAll(students) { students.map {|student| add(student[0], student[1])}.toList }
  
  add(name, grade) {
    if (_roster.values.any {|classStudents| classStudents.contains(name)}) return false
    _roster[grade] = this.grade(grade) + [name]
    StringComparator.sort(_roster[grade])
    return true
  }
}
