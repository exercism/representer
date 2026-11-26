public static class SaddlePoints
{
    public static IEnumerable<(int value, int colIndex)> MaxInRow(this int[,] matrix, int rowIndex)
    {
        var numCols = matrix.GetLength(1);

        var maxValue = matrix[rowIndex, 0];

        for (int colIndex = 0; colIndex < numCols; colIndex++)
            if (matrix[rowIndex, colIndex] > maxValue)
                maxValue = matrix[rowIndex, colIndex];

        List<(int value, int colIndex)> res = [];

        for (int colIndex = 0; colIndex < numCols; colIndex++)
            if (matrix[rowIndex, colIndex] == maxValue)
                res.Add((matrix[rowIndex, colIndex], colIndex));

        return res;
    }

    public static int MinInCol(this int[,] matrix, int colIndex)
    {
        var numRows = matrix.GetLength(0);

        var min = matrix[0, colIndex];

        for (int rowIndex = 0; rowIndex < numRows; rowIndex++)
            if (matrix[rowIndex, colIndex] < min)
                min = matrix[rowIndex, colIndex];

        return min;
    }


    public static IEnumerable<(int, int)> Calculate(int[,] matrix)
    {
        var (rows, _) = (matrix.GetLength(0), matrix.GetLength(1));

        List<(int rowIndex, int columnIndex)> res = [];

        for (var row = 0; row < rows; row++)
        {
            var maxesInRow = matrix.MaxInRow(row);
            foreach (var (value, colIndex) in maxesInRow)
            { 
                var minInCol = matrix.MinInCol(colIndex);
                if (value == minInCol)
                    res.Add((row + 1, colIndex + 1));
            }
            
        }

        return res;
    }
}
