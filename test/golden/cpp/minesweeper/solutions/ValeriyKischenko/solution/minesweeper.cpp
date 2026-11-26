#include <array>

#include "minesweeper.h"

namespace minesweeper {

namespace {
    constexpr char ZERO  = '0';
    constexpr char EMPTY = ' ';
    constexpr char MINE  = '*';
    constexpr std::array<int, 3> dirs{-1, 0, 1};

    char mines(int r, int c, int h, int w, const std::vector<std::string>& grid) 
    {
        int count{0};
        for (const int dr : dirs) {
            int nr = r + dr;
            if (nr < 0 || nr >= h)
                continue;
            for (const int dc : dirs) {
                int nc = c + dc;
                if (nc >= 0 && nc < w && grid[nr][nc] == MINE) {
                    count++;
                }
            }
        }
        return count == 0 ? EMPTY : ZERO + count;
    }
}

std::vector<std::string> annotate(const std::vector<std::string>& grid)
{
    if (grid.empty() || grid[0].empty()) {
        return grid;
    }
    const auto h = grid.size();
    const auto w = grid[0].size();
    std::vector<std::string> res;
    res.reserve(h);
    for (std::size_t r = 0; r < h; ++r) {
        std::string row;
        row.reserve(w);
        for (std::size_t c = 0; c < w; ++c) {
            char cell = grid[r][c];
            if (cell == EMPTY) {
                cell = mines(r, c, h, w, grid);
            }
            row.push_back(cell);
        }
        res.emplace_back(row);
    }

    return res;
}

}  // namespace minesweeper
