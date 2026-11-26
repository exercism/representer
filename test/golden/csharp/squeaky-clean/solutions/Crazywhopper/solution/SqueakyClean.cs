using System;
using System.Text.RegularExpressions;

public static class Identifier
{
    public static string Clean(string identifier)
    {
        string returnstring=identifier.Replace(' ','_');
        returnstring = System.Text.RegularExpressions.Regex.Replace(returnstring, @"\p{Cc}","CTRL");
        Regex rgx = new Regex(@"-");
        string[] result = rgx.Split(returnstring);
        if(result.Length>1){
            for (int element=1;element<result.Length;element++){
                System.Text.StringBuilder sb = new System.Text.StringBuilder(result[element]);
                sb[0] = System.Char.ToUpper(sb[0]);
                result[element]=sb.ToString();
            }
            returnstring="";
            for (int element=0;element<result.Length;element++){
                returnstring=returnstring+result[element];
            }            
        }
        returnstring=System.Text.RegularExpressions.Regex.Replace(returnstring, @"[0-9\p{C}]", "");
        returnstring=System.Text.RegularExpressions.Regex.Replace(returnstring, @"[\u03B2-\u03E1]", "");
        return returnstring;
    }
}
