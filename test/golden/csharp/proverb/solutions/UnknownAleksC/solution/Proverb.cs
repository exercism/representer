using System;

public static class Proverb
{
    public static string[] Recite(string[] subjects)
    {
        if (subjects.Length == 0) 
            return subjects;

        string[] proverbStory = new string[subjects.Length];
        for (int i = 0; i < subjects.Length; i++) {
            if (i == subjects.Length - 1) {
                proverbStory[i] = $"And all for the want of a {subjects[0]}.";
            } else {
            proverbStory[i] = $"For want of a {subjects[i]} the {subjects[i+1]} was lost.";
            };
        };
        return proverbStory;
    }
}