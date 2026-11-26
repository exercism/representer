using System.Text;

public static class RotationalCipher
{
    public static string Rotate(string text, int shiftKey)
    {
        StringBuilder ciphertext = new StringBuilder();

        for (int i = 0; i < text.Length; i++)
        {
            if ((text[i] >= 65 && text[i] <= 90))
            {
                ciphertext.Append((char)(text[i] + shiftKey <= 90 ? text[i] + shiftKey : ((text[i] + shiftKey) - 26)));
            }
            else if (text[i] >= 97 && text[i] <= 122)
            {
                ciphertext.Append((char)(text[i] + shiftKey <= 122 ? text[i] + shiftKey : ((text[i] - shiftKey) - 26)));
            }
            else
            {
                ciphertext.Append(text[i]);
            }
        }

        return ciphertext.ToString();
    }
}