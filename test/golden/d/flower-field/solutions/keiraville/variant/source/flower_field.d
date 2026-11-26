module flower_field;

import std.algorithm : max, min;

pure string[] annotate(immutable string[] garden)
{
    string[] result;
    size_t numRows = garden.length;
    if (numRows == 0)
    {
        return result;
    }
    size_t numColumns = garden[0].length;
    result.length = numRows;
    for (size_t row = 0; row < numRows; ++row)
    {
        string line;
        for (size_t column = 0; column < numColumns; ++column)
        {
            if (garden[row][column] == '*')
            {
                line ~= '*';
                continue;
            }
            char count = 0;
            for (size_t r = max(2, row) - 1; r < min(numRows, row + 2); ++r)
            {
                for (size_t c = max(1, column) - 1; c < min(numColumns, column + 2); ++c)
                {
                    if (garden[r][c] == '*')
                    {
                        ++count;
                    }
                }
            }

            if (count > 0)
            {
                line ~= '0' + count;
            }
            else
            {
                line ~= ' ';
            }
        }
        result[row] = line;
    }
    return result;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // No rows
    {
        immutable string[] garden = [
        ];
        string[] expected = [
        ];
        assert(annotate(garden) == expected);
    }

    static if (allTestsEnabled)
    {
        // No columns
        {
            immutable string[] garden = [
                "",
            ];
            string[] expected = [
                "",
            ];
            assert(annotate(garden) == expected);
        }

        // No flowers
        {
            immutable string[] garden = [
                "   ",
                "   ",
                "   ",
            ];
            string[] expected = [
                "   ",
                "   ",
                "   ",
            ];
            assert(annotate(garden) == expected);
        }

        // garden with only flowers
        {
            immutable string[] garden = [
                "***",
                "***",
                "***",
            ];
            string[] expected = [
                "***",
                "***",
                "***",
            ];
            assert(annotate(garden) == expected);
        }

        // Flower surrounded by spaces
        {
            immutable string[] garden = [
                "   ",
                " * ",
                "   ",
            ];
            string[] expected = [
                "111",
                "1*1",
                "111",
            ];
            assert(annotate(garden) == expected);
        }

        // Space surrounded by flowers
        {
            immutable string[] garden = [
                "***",
                "* *",
                "***",
            ];
            string[] expected = [
                "***",
                "*8*",
                "***",
            ];
            assert(annotate(garden) == expected);
        }

        // Horizontal line
        {
            immutable string[] garden = [
                " * * ",
            ];
            string[] expected = [
                "1*2*1",
            ];
            assert(annotate(garden) == expected);
        }

        // Horizontal line, flowers at edges
        {
            immutable string[] garden = [
                "*   *",
            ];
            string[] expected = [
                "*1 1*",
            ];
            assert(annotate(garden) == expected);
        }

        // Vertical line
        {
            immutable string[] garden = [
                " ",
                "*",
                " ",
                "*",
                " ",
            ];
            string[] expected = [
                "1",
                "*",
                "2",
                "*",
                "1",
            ];
            assert(annotate(garden) == expected);
        }

        // Vertical line, flowers at edges
        {
            immutable string[] garden = [
                "*",
                " ",
                " ",
                " ",
                "*",
            ];
            string[] expected = [
                "*",
                "1",
                " ",
                "1",
                "*",
            ];
            assert(annotate(garden) == expected);
        }

        // Cross
        {
            immutable string[] garden = [
                "  *  ",
                "  *  ",
                "*****",
                "  *  ",
                "  *  ",
            ];
            string[] expected = [
                " 2*2 ",
                "25*52",
                "*****",
                "25*52",
                " 2*2 ",
            ];
            assert(annotate(garden) == expected);
        }

        // Large garden
        {
            immutable string[] garden = [
                " *  * ",
                "  *   ",
                "    * ",
                "   * *",
                " *  * ",
                "      ",
            ];
            string[] expected = [
                "1*22*1",
                "12*322",
                " 123*2",
                "112*4*",
                "1*22*2",
                "111111",
            ];
            assert(annotate(garden) == expected);
        }
    }
}
