using System;

static class Badge
{
    public static string Print(int? id, string name, string? department)
    {
        string result = "";
        if (id != null)
            result = "[" + id.ToString() + "] - ";
        result = result + name + " - ";
        if (department != null)
            result = result + department.ToString().ToUpper();
        else
            result = result + "OWNER";
        return result;
    }
}
