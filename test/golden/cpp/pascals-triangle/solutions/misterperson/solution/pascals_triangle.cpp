#include "pascals_triangle.h"

namespace pascals_triangle {
    std::vector<std::vector<int>> generate_rows(const size_t rowCount)
    {
        std::vector<std::vector<int>> triangle(rowCount);

        for (size_t i = 0; i != rowCount; ++i)  {
            triangle[i].resize(i + 1, -1);
        }

        const auto binomial = [&triangle](const size_t row, const size_t pos) -> int {
            if (row == 0 || pos == 0 || row == pos) {
                return 1;
            }

            return triangle[row - 1][pos] + triangle[row - 1][pos - 1];
        };

        for (size_t j = 0; j != rowCount; ++j) {
            for (size_t i = 0; i <= j; ++i) {
                triangle[j][i] = binomial(j, i);
            }
        }

        return triangle;
    }
}  // namespace pascals_triangle
