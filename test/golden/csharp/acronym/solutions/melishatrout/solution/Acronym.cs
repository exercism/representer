using System;

public static class Acronym
{
    public static string Abbreviate(string phrase)
    {
        string [] p =  phrase.Split(new char[] {' ', '_', '-'}, StringSplitOptions.RemoveEmptyEntries);
        string abb = "";
        foreach(string word in p){

            abb += word[0].ToString().ToUpper();
            
        }
        return abb;
        
    }
}