using System;
using System.Collections.Generic;
using System.Linq;

public class GradeSchool
{
    private SortedDictionary<int, SortedSet<string>> roster = new();

    public bool Add(string student, int grade)
    {
        if (roster.Values.Any(students => students.Contains(student)))
            return false;

        roster.TryAdd(grade, new SortedSet<string>());
        roster[grade].Add(student);
        return false;
    }

    public IEnumerable<string> Roster() => roster.Values.SelectMany(students => students);

    public IEnumerable<string> Grade(int grade) => roster.TryGetValue(grade, out var students) ? students : Enumerable.Empty<string>();
}