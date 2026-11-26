module pascals_triangle;

pure int[][] rows(int count)
{
    int[][] result = new int[][](count);
    int[] previous;
    for (int i = 0; i < count; ++i)
    {
        int[] current = new int[](i + 1);
        current[0] = 1;
        for (int j = 1; j < i; ++j)
        {
            current[j] = previous[j - 1] + previous[j];
        }
        current[i] = 1;
        result[i] = current;
        previous = current;
    }
    return result;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Zero rows
    {
        int[][] expected = [
        ];
        assert(rows(0) == expected);
    }

    static if (allTestsEnabled)
    {
        // Single row
        {
            int[][] expected = [
                [1],
            ];
            assert(rows(1) == expected);
        }

        // Two rows
        {
            int[][] expected = [
                [1],
                [1, 1],
            ];
            assert(rows(2) == expected);
        }

        // Three rows
        {
            int[][] expected = [
                [1],
                [1, 1],
                [1, 2, 1],
            ];
            assert(rows(3) == expected);
        }

        // Four rows
        {
            int[][] expected = [
                [1],
                [1, 1],
                [1, 2, 1],
                [1, 3, 3, 1],
            ];
            assert(rows(4) == expected);
        }

        // Five rows
        {
            int[][] expected = [
                [1],
                [1, 1],
                [1, 2, 1],
                [1, 3, 3, 1],
                [1, 4, 6, 4, 1],
            ];
            assert(rows(5) == expected);
        }

        // Six rows
        {
            int[][] expected = [
                [1],
                [1, 1],
                [1, 2, 1],
                [1, 3, 3, 1],
                [1, 4, 6, 4, 1],
                [1, 5, 10, 10, 5, 1],
            ];
            assert(rows(6) == expected);
        }

        // Ten rows
        {
            int[][] expected = [
                [1],
                [1, 1],
                [1, 2, 1],
                [1, 3, 3, 1],
                [1, 4, 6, 4, 1],
                [1, 5, 10, 10, 5, 1],
                [1, 6, 15, 20, 15, 6, 1],
                [1, 7, 21, 35, 35, 21, 7, 1],
                [1, 8, 28, 56, 70, 56, 28, 8, 1],
                [1, 9, 36, 84, 126, 126, 84, 36, 9, 1],
            ];
            assert(rows(10) == expected);
        }
    }
}
