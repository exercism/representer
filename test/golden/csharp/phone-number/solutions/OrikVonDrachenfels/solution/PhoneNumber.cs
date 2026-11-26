using System.Text.RegularExpressions;

public class PhoneNumber
{
    public static string Clean(string phoneNumber)
    {
        var match = Regex.Match(phoneNumber, @"^\D*1?\D*([2-9]\d{2})\D*([2-9]\d{2})\D*(\d{4})\D*$");
        if (!match.Success) throw new ArgumentException();
        return match.Groups[1].Value + match.Groups[2].Value + match.Groups[3].Value;
    }
}