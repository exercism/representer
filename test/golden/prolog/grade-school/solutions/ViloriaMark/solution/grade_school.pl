create_school([]).
roster(School, Students) :-
    findall(S, member(_-S, School), Students).
add_student(School, Student, Grade, NewSchool) :-
    \+ memberchk(_-Student, School),
    ord_add_element(School, Grade-Student, NewSchool).
grade(School, Grade, OutStudents) :-
    findall(S, member(Grade-S, School), OutStudents).