using System;

static class Badge
{
    public static string Print(int? id, string name, string? department)
    {
        string I = (id == null ? "": $"[{id}] - "); 
        string D = (department ?? "owner").ToUpper();
        return I +name + " - " + D;
    }
}
