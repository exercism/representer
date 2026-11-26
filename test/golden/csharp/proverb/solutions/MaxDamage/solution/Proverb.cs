using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public static class Proverb
{
    public static string[] Recite(string[] subjects)
    {
        if (subjects.Length == 0)
        {
            return new string[0];
        }
        return subjects.Zip(subjects.Skip(1), (a, b) => $"For want of a {a} the {b} was lost.").
            Append($"And all for the want of a {subjects[0]}.").
            ToArray();
    }
}
//Classic solution
//
//var song = new List<string>();
//for (int i = 0; i<subjects.Length - 1; i++)
//{   
//    song.Add($"For want of a {subjects[i]} the {subjects[i + 1]} was lost.");
//}
//if (subjects.Length > 0)
//{
//    song.Add($"And all for the want of a {subjects[0]}.");
//}
//return song.ToArray();
