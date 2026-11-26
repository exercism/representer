unit class GradeSchool;

has %!students-by-grade;
has %!student-grades;

# Add a student to a grade, returns True if successful, False if already exists
method add(:$student, :$grade) {
    # Check if student already exists in any grade
    return False if %!student-grades{$student}:exists;
    
    # Add student to the specified grade
    %!students-by-grade{$grade} //= [];
    %!students-by-grade{$grade}.push: $student;
    
    # Track which grade the student is in
    %!student-grades{$student} = $grade;
    
    return True;
}

# Get roster for all students or for a specific grade
method roster(:$grade?) {
    # If grade is specified, return sorted students for that grade
    if $grade {
        return () unless %!students-by-grade{$grade}:exists;
        return %!students-by-grade{$grade}.sort.List;
    }
    
    # Return empty list if no students
    return () unless %!students-by-grade.elems;
    
    # Otherwise return all students sorted by grade then name
    my @result;
    for %!students-by-grade.keys.sort: { $^a.Int <=> $^b.Int } -> $g {
        @result.append: %!students-by-grade{$g}.sort;
    }
    
    return @result.List;
}