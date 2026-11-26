using System.Collections.Immutable;

using Point = (int Row, int Col);

public enum ConnectWinner
{
    White,
    Black,
    None
}

public class Connect
{
    private readonly Dictionary<Point, ConnectWinner> Grid = new();
    private readonly int MaxRow;
    private readonly int MaxCol;
    
    public Connect(string[] input)
    {
        for (int r = 0; r < input.Length; r++)
        {
            var row = input[r].Where(c => c != ' ').ToArray();
            for (int c = 0; c < row.Length; c++)
            {
                Grid[(r, c)] = row[c] switch
                {
                        '.' => ConnectWinner.None,
                        'O' => ConnectWinner.White,
                        'X' => ConnectWinner.Black,
                        _ => throw new ArgumentException("invalid grid")
                };
            }
        }
    }

    private IEnumerable<Point> GetNeighbors(Point point) =>
        new[]{
            (point.Row - 1, point.Col),
            (point.Row - 1, point.Col + 1),
            (point.Row, point.Col - 1),
            (point.Row, point.Col + 1),
            (point.Row + 1, point.Col - 1),
            (point.Row + 1, point.Col)
        }.Where(Grid.ContainsKey);

    private bool HasPath(ConnectWinner player, Func<Point, bool> isStart, Func<Point, bool> isEnd)
    {
        var visiting = new Queue<IList<Point>>();
        foreach (var point in Grid.Keys.Where(isStart))
        {
            if (Grid[point] == player)
                visiting.Enqueue([point]);
        }
        
        while (visiting.TryDequeue(out var current))
        {
            var lastPoint = current[^1];
            if (isEnd(lastPoint)) return true;

            foreach (var neighbor in GetNeighbors(lastPoint))
            {
                if (Grid[neighbor] == player && !current.Contains(neighbor))
                    visiting.Enqueue([..current, neighbor]);
            }
        }

        return false;
    }

    private bool WhiteHasPath()
    {
        var targetRow = Grid.Keys.Select(p => p.Row).Max();
        return HasPath(ConnectWinner.White, p => p.Row == 0, p => p.Row == targetRow);
    }

    private bool BlackHasPath()
    {
        var targetCol = Grid.Keys.Select(p => p.Col).Max();
        return HasPath(ConnectWinner.Black, p => p.Col == 0, p => p.Col == targetCol);
    }
    
    public ConnectWinner Result()
    {
        if (WhiteHasPath()) return ConnectWinner.White;
        if (BlackHasPath()) return ConnectWinner.Black;
        return ConnectWinner.None;
    }
}