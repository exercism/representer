public static class FlowerField
{
    public static string[] Annotate(string[] input)
    {
        var field = new string[input.Length];

        for (int y = 0; y < input.Length; y++)
        {
            var currentRow = new char[input[0].Length];
            for (int x = 0; x < input[0].Length; x++)
            {
                char currentChar = input[y][x];
                if (currentChar == '*') 
                {
                    currentRow[x] = currentChar;
                    continue;
                }
                
                int adjacentFlowers = 0;
                foreach ((int OffsetY, int OffsetX) relativePosition in _relativePositionsForNineTouchingSquares)
                {
                    var coordinates = (Y: y + relativePosition.OffsetY, X: x + relativePosition.OffsetX);
                    if (AreValidCoordinates(coordinates, input) && input[coordinates.Y][coordinates.X] == '*')
                    {
                        adjacentFlowers++;
                    }
                }

                if (adjacentFlowers == 0)
                {
                    currentRow[x] = ' ';
                }
                else
                {
                    currentRow[x] = (char)(adjacentFlowers + 48);
                }
            }
            field[y] = new string(currentRow);
        }
        
        return field;
    }

    private static (int, int)[] _relativePositionsForNineTouchingSquares = new (int Y, int X)[]
    {
        (-1, -1),
        (-1,  0),
        (-1,  1),
        ( 0, -1),
        ( 0,  0),
        ( 0,  1),
        ( 1, -1),
        ( 1,  0),
        ( 1,  1)
    };

    private static bool AreValidCoordinates((int Y, int X) coordinates, string[] input) => 
        coordinates.Y >= 0 && coordinates.Y < input.Length || 
        coordinates.X >= 0 && coordinates.X < input[0].Length;
}
