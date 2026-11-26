using System;

static class Badge
{
    public static string Print(int? id, string name, string? department)
    {
        string res = "";
        res += id == null ? "" : $"[{id}] - ";
        department = department ?? "owner";
        return res + $"{name} - {department.ToUpper()}";
    }
}
