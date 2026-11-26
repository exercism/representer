using System.Linq;

public static class RotationalCipher
{
    public static string Rotate(string text, int shiftKey) =>
        new string(text.Select((c) => RotateCharacter(c, shiftKey)).ToArray()); 

    private static char RotateCharacter(char c, int shiftKey) =>
        char.IsLetter(c) ? RotateLetter(c, shiftKey) : c;

    private static char RotateLetter(char c, int shiftKey)
    {
        char a = char.IsLower(c) ? 'a' : 'A';
        return (char)((c - a + shiftKey) % 26 + a);
    }
}