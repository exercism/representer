using System;
using System.Linq;
using System.Collections.Generic;

public static class DialingCodes
{
    public static Dictionary<int, string> GetEmptyDictionary() => new Dictionary<int, string>();

    public static Dictionary<int, string> GetExistingDictionary()
    {
        return new Dictionary<int, string>
        {
            {1, "United States of America"},
            {55, "Brazil"},
            {91, "India"}
        };
    }

    public static Dictionary<int, string> AddCountryToEmptyDictionary(int countryCode, string countryName)
    {
        var dict = new Dictionary<int, string>();
        dict.Add(countryCode, countryName);
        return dict;
    }

    public static Dictionary<int, string> AddCountryToExistingDictionary(
        Dictionary<int, string> existingDictionary, int countryCode, string countryName)
    {
        existingDictionary.Add(countryCode,countryName); 
        return existingDictionary;
    }

    public static string GetCountryNameFromDictionary(
        Dictionary<int, string> existingDictionary, int countryCode)
    {       
            bool check = existingDictionary.ContainsKey(countryCode);
                if (check) {
                    return existingDictionary[countryCode];
                } else {
                    return "";
                }     
    }

    public static bool CheckCodeExists(Dictionary<int, string> existingDictionary, int countryCode)
    {
        bool check = existingDictionary.ContainsKey(countryCode);
        return check;
    }

    public static Dictionary<int, string> UpdateDictionary(
        Dictionary<int, string> existingDictionary, int countryCode, string countryName)
    {
        bool check = existingDictionary.ContainsKey(countryCode);
        if (check){
            existingDictionary[countryCode] = countryName;
            return existingDictionary;
        } else {
            return existingDictionary;
        }
    }

    public static Dictionary<int, string> RemoveCountryFromDictionary(Dictionary<int, string> existingDictionary, int countryCode)
    {
        bool check = existingDictionary.ContainsKey(countryCode);
        if (check) {
            existingDictionary.Remove(countryCode);
            return existingDictionary;
        }
        return existingDictionary;
    }

    public static string FindLongestCountryName(Dictionary<int, string> existingDictionary)
    {
        var sort = from entry in existingDictionary orderby entry.Value.Length descending select entry;
        var key = sort.FirstOrDefault();

        if (key.Key == 0) {
            return "";
        } else {
            return existingDictionary[key.Key];
        }
    }
}