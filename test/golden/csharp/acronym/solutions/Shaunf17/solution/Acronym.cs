using System;

public static class Acronym
{
    public static string Abbreviate(string phrase)
    {
        string[] sentence = phrase.Split(new char[] { ' ', '_', '-' }, StringSplitOptions.RemoveEmptyEntries);
        string abberviation = "";
        foreach (string word in sentence)
        {
            abberviation += word[0].ToString().ToUpper();
        }
        return abberviation;
    }
}