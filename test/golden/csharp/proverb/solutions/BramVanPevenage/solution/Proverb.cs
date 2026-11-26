using System;

public static class Proverb
{
    public static string[] Recite(string[] subjects)
        {
            if (subjects.Length == 0)
                return Array.Empty<string>();
        
            String[] sentences = new String[subjects.Length];
            for (int i = 0; i < subjects.Length-1; i++)
            {
                sentences[i] = $"For want of a {subjects[i]} the {subjects[i+1]} was lost.";
            }
            sentences[sentences.Length-1] = $"And all for the want of a {subjects[0]}.";
            return sentences;
        }
}