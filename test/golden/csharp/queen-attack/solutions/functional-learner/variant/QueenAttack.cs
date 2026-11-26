using System;

public class Queen
{
    public Queen(int row, int column)
    {
        _ = !(row is >= 0 and < 8 && column is >= 0 and < 8) ? throw new ArgumentOutOfRangeException() : 0;
        Row = row;
        Column = column;
    }

    public int Row { get; }
    public int Column { get; }
}

public static class QueenAttack
{
    public static bool CanAttack(Queen white, Queen black)
    {
        var (a, b) = (white.Row - black.Row, white.Column - black.Column);
        return a == b || a == -b && a == 0 || b == 0;
    }

    public static Queen Create(int row, int column) => new Queen(row, column);
}