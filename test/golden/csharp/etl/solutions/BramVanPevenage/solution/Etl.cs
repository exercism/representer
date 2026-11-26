using System;
using System.Collections.Generic;

public static class Etl
{
    public static Dictionary<string, int> Transform(Dictionary<int, string[]> old)
        {
            Dictionary<String, int> newSys = new Dictionary<String, int>();
            foreach (var item in old)
            {
                foreach (var element in old[item.Key])
                {
                    newSys.Add(element.ToLower(), item.Key);
                }
            }
            return newSys;
        }
}