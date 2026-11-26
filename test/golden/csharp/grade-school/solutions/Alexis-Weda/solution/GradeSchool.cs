using System;
using System.Collections.Generic;
using System.Linq;

public class GradeSchool
{
    private Dictionary<string, int> Students = new();

    public bool Add(string student, int grade) => Students.TryAdd(student, grade);

    public IEnumerable<string> Roster() => Students.OrderBy(k => k.Value).ThenBy(k => k.Key).Select(k => k.Key);

    public IEnumerable<string> Grade(int grade) => Students.Where(k => k.Value == grade).OrderBy(k => k.Key).Select(k => k.Key);
}