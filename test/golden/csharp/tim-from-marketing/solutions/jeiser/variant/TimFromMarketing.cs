using System;
using System.Text;

static class Badge
{
    public static string Print(int? id, string name, string? department)
    {
        StringBuilder sb = new StringBuilder();
        string tmpStr;
        if(id?.ToString().Length > 0) 
        {
            sb.Append($"[{id}] - ");
        }

        sb.Append($"{name} - ");

        if(department != null) 
        {
            sb.Append("OWNER");
        } else {
            sb.Append(department.ToUpper());
        }

        return sb.ToString();
        
    }
}
