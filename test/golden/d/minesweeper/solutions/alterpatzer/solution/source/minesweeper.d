module minesweeper;

pure int bombs_around(immutable string[] field, int r, int c)
{
    int s = 0;
    for (int dr = -1; dr != 2; ++dr) {
        for (int dc = -1; dc != 2; ++dc) {
            int y = r + dr;
            int x = c + dc;
            if (y >= 0 && y != field.length &&
                x >= 0 && x != field[r].length) {
                s += field[y][x] == '*';
            }
        }
    }
    return s;
}

pure string[] annotate(immutable string[] minefield)
{
    // implement this function
    string[] result;
    for (int r = 0; r != minefield.length; ++r) {
        string row;
        for (int c = 0; c != minefield[r].length; ++c) {
            if (minefield[r][c] == '*') {
                row ~= '*';
            } else {
                int bombs = minefield.bombs_around(r, c);
                if (bombs == 0) {
                    row~= ' ';
                } else {
                    row ~= bombs + '0';
                }
            }
        }
        result ~= row;
    }
    return result;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // No rows
    {
        immutable string[] minefield = [
        ];
        string[] expected = [
        ];
        assert(annotate(minefield) == expected);
    }

    static if (allTestsEnabled)
    {
        // No columns
        {
            immutable string[] minefield = [
                "",
            ];
            string[] expected = [
                "",
            ];
            assert(annotate(minefield) == expected);
        }

        // No mines
        {
            immutable string[] minefield = [
                "   ",
                "   ",
                "   ",
            ];
            string[] expected = [
                "   ",
                "   ",
                "   ",
            ];
            assert(annotate(minefield) == expected);
        }

        // Minefield with only mines
        {
            immutable string[] minefield = [
                "***",
                "***",
                "***",
            ];
            string[] expected = [
                "***",
                "***",
                "***",
            ];
            assert(annotate(minefield) == expected);
        }

        // Mine surrounded by spaces
        {
            immutable string[] minefield = [
                "   ",
                " * ",
                "   ",
            ];
            string[] expected = [
                "111",
                "1*1",
                "111",
            ];
            assert(annotate(minefield) == expected);
        }

        // Space surrounded by mines
        {
            immutable string[] minefield = [
                "***",
                "* *",
                "***",
            ];
            string[] expected = [
                "***",
                "*8*",
                "***",
            ];
            assert(annotate(minefield) == expected);
        }

        // Horizontal line
        {
            immutable string[] minefield = [
                " * * ",
            ];
            string[] expected = [
                "1*2*1",
            ];
            assert(annotate(minefield) == expected);
        }

        // Horizontal line, mines at edges
        {
            immutable string[] minefield = [
                "*   *",
            ];
            string[] expected = [
                "*1 1*",
            ];
            assert(annotate(minefield) == expected);
        }

        // Vertical line
        {
            immutable string[] minefield = [
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
            assert(annotate(minefield) == expected);
        }

        // Vertical line, mines at edges
        {
            immutable string[] minefield = [
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
            assert(annotate(minefield) == expected);
        }

        // Cross
        {
            immutable string[] minefield = [
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
            assert(annotate(minefield) == expected);
        }

        // Large minefield
        {
            immutable string[] minefield = [
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
            assert(annotate(minefield) == expected);
        }
    }
}
