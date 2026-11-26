public class Robot
{
    private const string LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private string _name;
    private static HashSet<string> _usedNames = new();

    public Robot() => _name = GenerateName();

    public string Name => _name;

    public void Reset() => _name = GenerateName();

    private string GenerateName()
    {
        string candidateName;
        do
        {
            candidateName = $"{GenerateLetter()}{GenerateLetter()}{GenerateDigit()}{GenerateDigit()}{GenerateDigit()}";
        }
        while (_usedNames.Contains(candidateName));
        _usedNames.Add(candidateName);
        return candidateName;
    }

    private char GenerateLetter() => LETTERS[new Random().Next(LETTERS.Length)];

    private char GenerateDigit() => new Random().Next(11).ToString()[0];
}