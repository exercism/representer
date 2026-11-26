using System;

public static class RotationalCipher
{
    public static string Rotate(string text, int shiftKey)
    {
        string UnChiper = "abcdefghijklmnopqrstuvwxyz";
		string Chiper, Search;
		string result = "";
		int loc;
		
		Chiper = UnChiper.Substring(shiftKey, UnChiper.Length-shiftKey) + UnChiper.Substring(0, shiftKey);
		
		for (int i = 0; i < text.Length; i++)
		{
			if (Char.IsLetter(text, i) == true)
			{
				if (Char.IsUpper(text, i) == true)
				{
					Search = text.Substring(i, 1).ToLower();
					loc = UnChiper.IndexOf(Search);
					
					result = result + Chiper.Substring(loc, 1).ToUpper();
				} else {
					Search = text.Substring(i, 1).ToString();
					loc = UnChiper.IndexOf(Search);
					
					result = result + Chiper.Substring(loc, 1).ToString();
				}
			} else { result = result + text.Substring(i,1).ToString();}
			
		}
		
		return result;
    }
}