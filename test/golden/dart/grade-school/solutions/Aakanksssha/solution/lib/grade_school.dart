class GradeSchool {
  final Map<int, Set<String>> _roster = {};

  /// Add a list of (name, grade) records and return success status for each
  List<bool> add(List<(String, int)> students) {
    final result = <bool>[];

    for (final (name, grade) in students) {
      // Ensure student isn't already in any grade
      if (_roster.values.any((s) => s.contains(name))) {
        result.add(false);
        continue;
      }

      _roster.putIfAbsent(grade, () => <String>{});
      _roster[grade]!.add(name);
      result.add(true);
    }

    return result;
  }

  /// Get sorted list of students in a given grade
  List<String> grade(int grade) {
    final students = _roster[grade];
    if (students == null) return [];
    return students.toList()..sort();
  }

  /// Get full sorted roster: grade by grade, names alphabetically
  List<String> roster() {
    final sorted = <String>[];
    final grades = _roster.keys.toList()..sort();
    for (final g in grades) {
      final students = _roster[g]!.toList()..sort();
      sorted.addAll(students);
    }
    return sorted;
  }
}