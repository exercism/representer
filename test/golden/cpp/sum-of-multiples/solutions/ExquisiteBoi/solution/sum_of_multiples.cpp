#include "sum_of_multiples.h"
#include <vector>
#include <algorithm>
#include <numeric>

namespace sum_of_multiples
{
    int to(std::vector<int> base_values, int level)
    {
        std::vector<std::vector<int>> sequences(base_values.size());
        int i{0};
        for (auto &vec : sequences)
        {
            int n{1};
            int base_val = base_values[i];
            while (base_val * n < level)
            {
                vec.emplace_back(base_val * n);
                ++n;
            };
            ++i;
        }
        std::vector<int> merged_sets{};

        for (auto &vec : sequences)
        {
            std::move(vec.begin(), vec.end(), std::back_inserter(merged_sets));
        }
        if (sequences.size() > 1)
        {
            auto ms_it = merged_sets.begin();
            for (auto it{sequences.begin()}; ms_it != merged_sets.end(); it += 2)
            {
                if (!(std::distance(ms_it, merged_sets.end()) == static_cast<int>((sequences.back()).size())))
                {
                    std::inplace_merge(ms_it, ms_it + (it->size()), ms_it + it->size() + (it + 1)->size());
                    ms_it += it->size() + (it + 1)->size();
                }
                else
                {
                    std::inplace_merge(merged_sets.begin(), ms_it, merged_sets.end());
                    break;
                }
            }
            auto it = std::unique(merged_sets.begin(), merged_sets.end());
            merged_sets.erase(it, merged_sets.end());
        }
        // std::sort(merged_sets.begin(), merged_sets.end());

        return std::accumulate(merged_sets.begin(), merged_sets.end(), 0);
    }
} // namespace sum_of_multiples