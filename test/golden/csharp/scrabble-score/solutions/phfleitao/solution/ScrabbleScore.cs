using System;
using System.Linq;

public static class ScrabbleScore
{
    public static int Score(string input) => input.Sum(x => x.GetPoint());

    public static int GetPoint(this char letter)
    {
        letter = char.ToUpper(letter);
        if ("A, E, I, O, U, L, N, R, S, T".Contains(letter)) return 1;
        if ("D, G".Contains(letter)) return 2;
        if ("B, C, M, P".Contains(letter)) return 3;
        if ("F, H, V, W, Y".Contains(letter)) return 4;
        if ("K".Contains(letter)) return 5;
        if ("J, X".Contains(letter)) return 8;
        if ("Q, Z".Contains(letter)) return 10;
        return 0;
    }
}