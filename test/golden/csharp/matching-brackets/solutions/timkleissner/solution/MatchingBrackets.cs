using System;
using System.Text;
using System.Linq;

public static class MatchingBrackets
{   
    private static readonly string allBrackets = "()[]{}";
    
    public static bool IsPaired(string input)
    {
        string brackets = makeStringOfBrackets(input);
        if(brackets.Equals("")) return true;
        if(!checkIfValidForTest(brackets)) return false;
        return checkPairedBrackets();

        bool checkPairedBrackets(){
            var sb = new StringBuilder(brackets);
            for(int i = 0; i < sb.Length;){
                try{
                    if(sb[i] == '(' && i+1 == sb.ToString().IndexOf(')')){
                        sb.Replace(")", "").Replace("(", "");
                        i = 0;
                    } else if(sb[i] == '[' && i+1 == sb.ToString().IndexOf(']')) {
                        sb.Replace("]", "").Replace("[", "");
                        i = 0;
                    } else if(sb[i] == '{' && i+1 == sb.ToString().IndexOf('}')) {
                        sb.Replace("}", "").Replace("{", "");
                        i = 0;
                    } else { i++; }
                } catch (Exception e) { break; }
            }
            return sb.ToString() == "";
        }
    }

    private static bool checkIfValidForTest(string str) => 
        (str.Length >= 2 && str.Length % 2 == 0) && 
        (str[0] == '(' || str[0] == '[' || str[0] == '{');

    private static string makeStringOfBrackets(string str){
        var bracketString = new StringBuilder("");
        foreach(char c in str)
            if(allBrackets.Contains(c))
                bracketString.Append(c);
        
        return bracketString.ToString();
    }
}