using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

using static System.Net.Mime.MediaTypeNames;

public class Anagram
{
    private readonly string _baseWord;
    public Anagram(string baseWord)
    {
        _baseWord = baseWord.ToLower();
    }

    public string[] FindAnagrams(string[] potentialMatches)
    {
        var result = new List<string>();

        foreach (var x in potentialMatches)
        {
            if (IsAnagram(x.ToLower()))
            {
                result.Add(x);
            }
        }

        return result.ToArray();
    }
    private bool IsAnagram(string word)
    {
        if (_baseWord.Length != word.Length || word == _baseWord)
        {
            return false;
        }

        var letterCounts = new Dictionary<char, int>();

        foreach (var c in _baseWord)
        {
            if (letterCounts.ContainsKey(c))
            {
                letterCounts[c]++;
            }
            else
            {
                letterCounts[c] = 1;
            }
        }

        foreach (var c in word)
        {
            if (!letterCounts.ContainsKey(c) || letterCounts[c] == 0)
            {
                return false;
            }
            letterCounts[c]--;
        }

        return true;
    }
}
