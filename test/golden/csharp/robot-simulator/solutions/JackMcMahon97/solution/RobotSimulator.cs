using System;

public enum Direction
{
    North,
    East,
    South,
    West
}
public class RobotSimulator
{
    public Direction Direction { get; private set; }
    public int X { get; private set; }
    public int Y { get; private set; }
    public RobotSimulator(Direction direction, int x, int y)
    {
        Direction = direction;
        X = x;
        Y = y;
    }
    public void Move(string instructions)
    {
        foreach (var ch in instructions)
            switch (ch)
            {
                case 'A':
                    Advance();
                    break;
                case 'R':
                    TurnRight();
                    break;
                case 'L':
                    TurnLeft();
                    break;
            }
    }
    private void Advance()
    {
        switch (Direction)
        {
            case Direction.North: Y += 1; break;
            case Direction.South: Y -= 1; break;
            case Direction.East: X += 1; break;
            case Direction.West: X -= 1; break;
            default: throw new ArgumentOutOfRangeException();
        }
    }
    private void TurnRight()
    {
        Direction++;
        if ((int)Direction > 3)
            Direction = 0;
    }
    private void TurnLeft()
    {
        Direction--;
        if ((int)Direction < 0)
            Direction = (Direction)3;
    }
}