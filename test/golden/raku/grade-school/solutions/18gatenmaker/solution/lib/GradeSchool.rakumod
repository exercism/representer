unit class GradeSchool;
has %!grades{UInt} of Array[Str];

method add (Str :$student, UInt :$grade --> Bool) {
    return False if %!grades.values.any (cont) $student;
    %!grades{$grade}.push($student);
    return True;
}

multi method roster { %!grades.keys.sort.map({self.roster(grade => $_)}).flat.List }

multi method roster (UInt :$grade!) {(%!grades{$grade}||[]).sort.List }
