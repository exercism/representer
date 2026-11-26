using System;

public static class GameOfLife
{
    public static int[,] Tick(int[,] matrix)
    {
        List<(int x, int y)> moves = new () { (-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1) };
        int rowLength = matrix.GetLength(0);
        int colLength = matrix.GetLength(1);
        int[,] newMatrix = new int[rowLength, colLength];
    
        for(int i = 0; i < rowLength; i++)
        {
            for(int j= 0 ; j < colLength; j++)
            {
                int liveCount = 0;
                foreach (var move in moves)
                {
                    int xPosition = i + move.x;
                    int yPosition = j + move.y;
    
                    if (InBound(xPosition, yPosition, rowLength, colLength))
                    {
                        if (matrix[xPosition, yPosition] == 1) liveCount++;
                    }
                }
    
                if (matrix[i, j] == 1)
                {
                    if (liveCount == 2 || liveCount == 3)
                        newMatrix[i, j] = 1;
                    else
                        newMatrix[i, j] = 0;
                }
                else if (matrix[i, j] == 0)
                {
                    if (liveCount == 3) newMatrix[i, j] = 1;
                }
            }
        }
    
        return newMatrix;
    }
    
    public static bool InBound(int xMove, int yMove, int rowLength, int colLength)
    {
        return (xMove >= 0 && xMove < rowLength) && (yMove >= 0 && yMove < colLength);
    }
}
