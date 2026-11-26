using System;
using System.Collections.Generic;
using System.Text;

public static class House
{
    private static readonly List<(string, string)> vals = new()
    {
        ("the house", "Jack built"),
        ("the malt", "lay in"),
        ("the rat", "ate"),
        ("the cat", "killed"),
        ("the dog", "worried"),
        ("the cow with the crumpled horn", "tossed"),
        ("the maiden all forlorn", "milked"),
        ("the man all tattered and torn", "kissed"),
        ("the priest all shaven and shorn", "married"),
        ("the rooster that crowed in the morn", "woke"),
        ("the farmer sowing his corn", "kept"),
        ("the horse and the hound and the horn", "belonged to"),
    };

    public static string Recite(int verseNumber)
    {
        StringBuilder sb = new();
        for (int i = verseNumber - 1; i >= 0; i--)
        {
            (string a, string b) = vals[i];
            if (i == verseNumber - 1) sb.Append($"This is {a} that {b}");
            else sb.Append($" {a} that {b}");
        }
        sb.Append('.');
        return sb.ToString();
    }

    public static string Recite(int startVerse, int endVerse)
    {
        StringBuilder sb = new();
        for (int i = startVerse; i <= endVerse; i++)
        {
            if (i == endVerse) sb.Append(Recite(i));
            else sb.Append(Recite(i) + '\n');
        }
        return sb.ToString();
    }
}