using System;
using System.Text.RegularExpressions;
using System.Linq;

public class PhoneNumber
{
    private static readonly int[] validCodes = { 1 };
    
    public static string Clean(string phoneNumber)
    {
        Match match = Regex.Match(phoneNumber, @"^(\D*(?<countryCode>\d))?\D*((?<areaCode>(?<areaN>\d)\d{2}))\D*((?<exchangeCode>(?<exchangeN>\d)\d{2}))\D*(?<suscriber>\d{4})\D*$");
        if (!match.Success) throw new ArgumentException();
        if (int.TryParse(match.Groups["countryCode"].Value, out int countryCode))
        {
            if (!validCodes.Contains(countryCode)) throw new ArgumentException();
        }
        
        int areaN = int.Parse(match.Groups["areaN"].Value);
        int exchangeN = int.Parse(match.Groups["exchangeN"].Value);
        int areaCode = int.Parse(match.Groups["areaCode"].Value);
        int exchangeCode = int.Parse(match.Groups["exchangeCode"].Value);
        int suscriber = int.Parse(match.Groups["suscriber"].Value);
        
        if (areaN < 2 || exchangeN < 2) throw new ArgumentException();
        
        return string.Concat(areaCode, exchangeCode, suscriber);
    }
}