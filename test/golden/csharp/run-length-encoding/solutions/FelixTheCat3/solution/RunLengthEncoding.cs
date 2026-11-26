using System;

public static class RunLengthEncoding
{
    public static string Encode(string input)
    {
        if (input == "") //Catch Blank input
            return "";
        string encoded = string.Empty;
        input = input + "~"; //Extra character at end so that the 'i-1' reference is valid for the last char in the input
        int count = 0;
        char currentLetter = input[0];
        for (int i = 0; i <= (input.Length - 1); i++)
        {
            if (i == (input.Length - 1)) //if at end of input string
            {
                if (count > 1) //only print count if > 1
                    encoded += count.ToString();
                encoded += currentLetter.ToString();
                encoded += input[i].ToString();
                break;
            }
                
            if (input[i] == currentLetter) //count number of time the current letter occurs
            {
                count++;
                continue;
            }
            if (count > 1) //only print count if > 1
                encoded += count.ToString();   
            // "else"
            encoded += currentLetter.ToString();
            currentLetter = input[i]; //set next currentLetter
            count = 1; //reset count for next letter
        }
        encoded = encoded.TrimEnd('~'); //Remove control character '~' from end of 'encoded' string
        return encoded;
    }
    public static string Decode(string input)
    {
        string decoded = string.Empty;
        string str_count = string.Empty;
        for (int i = 0; i <= (input.Length - 1); i++)
        {
            //if current char is a letter....if currentchar is a number
            if (Char.IsNumber(input[i]))
                str_count += input[i]; //grab all digits of the number
            if (Char.IsLetter(input[i]) || Char.IsWhiteSpace(input[i]))
                {
                    if (str_count == string.Empty) //if letter doesn't have a number pre-fix
                        {
                            decoded += input[i];
                            str_count = string.Empty;
                            continue;
                        }
                    //"else" parse (string)count to int
                    int int_count = Int32.Parse(str_count);
                    for (int j = 1; j <= int_count; j++) //add current letter to 'decoded' string int(count) times
                        decoded += input[i];
                    str_count = string.Empty; //reset count for next letter
                }
        }
        return decoded;
    }
}
