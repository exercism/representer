using System;
using System.Text;

public static class RunLengthEncoding
{
    
    public static string Encode(string input)
    {
        if (input == "") return input;

        byte count = 0;
        char current = input[0];
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < input.Length; i++)
        {
            if (input[i] == current) count++;

            else
            {
                if (count > 1) sb.Append(count);
                sb.Append(current);
                current = input[i];
                count = 1;
            }
        }
        if (count > 1) sb.Append(count);
        sb.Append(current);
        return sb.ToString();
    }

    public static string Decode(string input)
    {
        if (input.Length == 0) return input;
        
        StringBuilder numHolder = new StringBuilder();
        StringBuilder decoded = new StringBuilder();
        int count = 0;

        for (int i = 0; i < input.Length; i++)
        {
            while (char.IsNumber(input[i]))
            {
                numHolder.Append(input[i]);
                i++;
            }

            if (numHolder.Length > 0) count = int.Parse(numHolder.ToString());
            
            while (count > 1)
            {
                decoded.Append(input[i]);
                count--;
            }
            decoded.Append(input[i]);
            numHolder.Clear();
            count = 0;
        }
        return decoded.ToString();
    }
}

