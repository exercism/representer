#include "minesweeper.h"

namespace minesweeper {
    std::vector<std::string> annotate(std::vector<std::string> input) {
        std::vector<std::string> output(input);
        int rows, cols;
        if (input.size() == 0)
            return output;
        if (input[0].length() == 0)
            return output;
        rows = input.size();
        cols = input[0].length();

        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                int count = 0;
                if (input[r][c] == '*')
                    continue;
                if (r - 1 >= 0) {
                    if (input[r - 1][c] == '*')
                        count++;
                    if (c - 1 >= 0 && input[r - 1][c - 1] == '*')
                        count++;
                    if (c + 1 < cols && input[r - 1][c + 1] == '*')
                        count++;
                }
                if (r + 1 < rows) {
                    if (input[r + 1][c] == '*')
                        count++;
                    if (c - 1 >= 0 && input[r + 1][c - 1] == '*')
                        count++;
                    if (c + 1 < cols && input[r + 1][c + 1] == '*')
                        count++;
                }
                if (c - 1 >= 0 && input[r][c - 1] == '*')
                    count++;
                if (c + 1 < cols && input[r][c + 1] == '*')
                    count++;
                if (count > 0)
                    output[r][c] = (char)((int)'0' + count);
            }
        }
        
        return output;
    }
}  // namespace minesweeper
