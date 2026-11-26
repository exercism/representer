module game_of_life;

import std.algorithm : max, min;

pure int[][] tick(immutable int[][] matrix)
{
    int[][] result;
    size_t numRows = matrix.length;
    if (numRows == 0)
    {
        return result;
    }
    size_t numColumns = matrix[0].length;
    result.length = numRows;
    for (size_t row = 0; row < numRows; ++row)
    {
        result[row].length = numColumns;
        for (size_t column = 0; column < numColumns; ++column)
        {
            int previous = matrix[row][column];
            int count = -previous;
            for (size_t r = max(1, row) - 1; r < min(numRows, row + 2); ++r)
            {
                for (size_t c = max(1, column) - 1; c < min(numColumns, column + 2); ++c)
                {
                    count += matrix[r][c];
                }
            }

            if (count == 3 || (count == 2 && previous == 1))
            {
                result[row][column] = 1;
            }
        }
    }
    return result;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Empty matrix
    {
        immutable int[][] matrix = [
        ];
        int[][] expected = [
        ];
        assert(tick(matrix) == expected);
    }

    static if (allTestsEnabled)
    {
        // Live cells with zero live neighbors die
        {
            immutable int[][] matrix = [
                [0, 0, 0],
                [0, 1, 0],
                [0, 0, 0],
            ];
            int[][] expected = [
                [0, 0, 0],
                [0, 0, 0],
                [0, 0, 0],
            ];
            assert(tick(matrix) == expected);
        }

        // Live cells with only one live neighbor die
        {
            immutable int[][] matrix = [
                [0, 0, 0],
                [0, 1, 0],
                [0, 1, 0],
            ];
            int[][] expected = [
                [0, 0, 0],
                [0, 0, 0],
                [0, 0, 0],
            ];
            assert(tick(matrix) == expected);
        }

        // Live cells with two live neighbors stay alive
        {
            immutable int[][] matrix = [
                [1, 0, 1],
                [1, 0, 1],
                [1, 0, 1],
            ];
            int[][] expected = [
                [0, 0, 0],
                [1, 0, 1],
                [0, 0, 0],
            ];
            assert(tick(matrix) == expected);
        }

        // Live cells with three live neighbors stay alive
        {
            immutable int[][] matrix = [
                [0, 1, 0],
                [1, 0, 0],
                [1, 1, 0],
            ];
            int[][] expected = [
                [0, 0, 0],
                [1, 0, 0],
                [1, 1, 0],
            ];
            assert(tick(matrix) == expected);
        }

        // Dead cells with three live neighbors become alive
        {
            immutable int[][] matrix = [
                [1, 1, 0],
                [0, 0, 0],
                [1, 0, 0],
            ];
            int[][] expected = [
                [0, 0, 0],
                [1, 1, 0],
                [0, 0, 0],
            ];
            assert(tick(matrix) == expected);
        }

        // Live cells with four or more neighbors die
        {
            immutable int[][] matrix = [
                [1, 1, 1],
                [1, 1, 1],
                [1, 1, 1],
            ];
            int[][] expected = [
                [1, 0, 1],
                [0, 0, 0],
                [1, 0, 1],
            ];
            assert(tick(matrix) == expected);
        }

        // Bigger matrix
        {
            immutable int[][] matrix = [
                [1, 1, 0, 1, 1, 0, 0, 0],
                [1, 0, 1, 1, 0, 0, 0, 0],
                [1, 1, 1, 0, 0, 1, 1, 1],
                [0, 0, 0, 0, 0, 1, 1, 0],
                [1, 0, 0, 0, 1, 1, 0, 0],
                [1, 1, 0, 0, 0, 1, 1, 1],
                [0, 0, 1, 0, 1, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 1, 1],
            ];
            int[][] expected = [
                [1, 1, 0, 1, 1, 0, 0, 0],
                [0, 0, 0, 0, 0, 1, 1, 0],
                [1, 0, 1, 1, 1, 1, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 1],
                [1, 1, 0, 0, 1, 0, 0, 1],
                [1, 1, 0, 1, 0, 0, 0, 1],
                [1, 0, 0, 0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0, 0, 1, 1],
            ];
            assert(tick(matrix) == expected);
        }
    }
}
