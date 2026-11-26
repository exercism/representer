using System;
using System.Collections.Generic;
using System.Linq;

public static class Languages
{
    private const string ExcitingLanguage = "C#";

    public static List<string> NewList() => new();

    public static List<string> GetExistingLanguages() => new() {"C#", "Clojure", "Elm" };

    public static List<string> AddLanguage(List<string> languages, string language) => languages.Append(language).ToList();
  
    public static int CountLanguages(List<string> languages) => languages.Count;

    public static bool HasLanguage(List<string> languages, string language) => languages.Contains(language);

    public static List<string> ReverseList(List<string> languages) => languages.Reverse<string>().ToList();

    public static bool IsExciting(List<string> languages)
    {
        if (languages.Count == 0)
        {
            return false;
        }

        if (languages.First() == ExcitingLanguage)
        {
            return true;
        }
        
        return languages.Count is 2 or 3 && languages.ElementAt(1) == ExcitingLanguage;
    }

    public static List<string> RemoveLanguage(List<string> languages, string language)
    {
        languages.Remove(language);
        return languages;
    }

    public static bool IsUnique(List<string> languages) => languages.Distinct().Count() == languages.Count;
}
