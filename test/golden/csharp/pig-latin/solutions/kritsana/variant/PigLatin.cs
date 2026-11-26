public static class PigLatin
{
    private static string suffix = "ay";
    private static List<char> vowels = ['a', 'e', 'i', 'o', 'u'];
    private static List<string> rule1Prefixs = ["xr", "yt"];
    
    public static string Translate(string text)
    {
        string[] words = text.Split();
        List<string> pigLatinTexts =  [];
        foreach (string word in words)
        {
            pigLatinTexts.Add(ByWord(word));
        }

        return string.Join(" ", pigLatinTexts);
    } 

    private static string ByWord(string word) {
        // rule 1
        if (word.Length >= 2 && rule1Prefixs.Contains(word.Substring(0, 2)))
        {
            return $"{word}{suffix}";
        }
        if (word.Length >= 1 && IsVowel(word[0])) {
            return $"{word}{suffix}";
        }

        var processChar = "";
        char beforeChar = '\0';
        var remainInWord = word;
        foreach(var c in word) {
            if (IsVowel(c)) {
                if (beforeChar == 'q' && c == 'u')
                {
                    remainInWord = remainInWord.Substring(1);
                    return $"{remainInWord}{processChar}{c}{suffix}";
                }
                
                return $"{remainInWord}{processChar}{suffix}";
            }else {
                if (c == 'y' || beforeChar != '\0')
                {
                    return $"{remainInWord}{processChar}{suffix}";
                }
            }

            remainInWord = remainInWord.Substring(1);
            processChar += c;
            beforeChar = c;
        }

        return "";
    }

    private static bool IsVowel(char c)
    {
        return vowels.Contains(c);
    }
}