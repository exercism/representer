using System;

public static class RotationalCipher
{ 
    public static string Rotate(string text, int shiftKey)
    {
        char[] table = new char[52];
        for(int i=0;i<26;i++)
            table[i] = (char)('a'+(i+shiftKey)%26);
        for(int i=0;i<26;i++)
            table[i+26] = (char)('A'+(i+shiftKey)%26);
        char[] array = text.ToCharArray();
        string cipher = "";
        for(int i=0;i<array.Length;i++){
            if(Char.IsLetter(array[i]) && Char.IsLower(array[i]))
                cipher += table[array[i]-'a'];
            if(Char.IsLetter(array[i]) && Char.IsUpper(array[i]))
                cipher += table[(array[i]-'A')+26];
            if(!Char.IsLetter(array[i]))
                cipher += array[i];
        }
        return cipher;
    }
}