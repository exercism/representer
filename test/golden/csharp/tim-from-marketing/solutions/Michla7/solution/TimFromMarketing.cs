using System;

static class Badge
{
    static string badge="";
    public static string Print(int? id, string name, string? department)
    {
        badge = 
            id != null & !string.IsNullOrEmpty(department) ?
            string.Format("[{0}] - {1} - {2}", id, name, department.ToUpper()) :
            id == null & !string.IsNullOrEmpty(department) ?
            string.Format("{0} - {1}", name, department.ToUpper()) :
            id != null & string.IsNullOrEmpty(department) ?
             string.Format("[{0}] - {1} - OWNER", id, name) :
             string.Format("{0} - OWNER", name);

        return badge;
    }
}
