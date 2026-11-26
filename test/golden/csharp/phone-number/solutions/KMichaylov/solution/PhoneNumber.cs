using System;
using System.Text.RegularExpressions;
public class PhoneNumber
{
    public static string Clean(string phoneNumber)
    {
        var answerPhoneNumber = ReplaceNonDigits(phoneNumber);
        var regex =  new Regex(@"^\+?1?[-. ]*\(?([2-9][0-9]{2})\)?[-. ]*?([2-9][0-9]{2})[-. ]*([0-9]{4})[-. ]*$");
        if (regex.IsMatch(phoneNumber))
            return answerPhoneNumber;
        else
           throw new ArgumentException();
        return "";
    }

    public static string ReplaceNonDigits(string number)
    {
        string result = "";
        bool first = true;
        foreach(var symbol in number)
        {
            if(char.IsDigit(symbol))
            { 
                if(first && symbol == '1')
                {
                    first = false;
                    continue;
                }    
                result+=symbol;
            }
        }
        return result;
    }
}