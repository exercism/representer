using System;

static class Badge
{
    public static string Print(int? id, string name, string? department)
    {
        string locId = "";
        string dep = "OWNER";
        if(id != null){
            locId=$"[{id}] - ";
        }
        if(department != null){
            dep = department.ToUpper();
        }
    
        return $"{locId}{name} - {dep}";
    }
}
