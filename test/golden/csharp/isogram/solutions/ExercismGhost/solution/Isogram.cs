using System.Linq;

public static class Isogram
{
    public static bool IsIsogram(string word)
    {
        var loweredChars = word.ToLower().Where(char.IsLetter).ToList();
        return loweredChars.Distinct().Count() == loweredChars.Count;
    }
}
