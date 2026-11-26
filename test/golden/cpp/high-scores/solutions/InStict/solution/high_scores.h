#pragma once

#include <vector>
#include<unordered_set>

namespace arcade {
    int getMax(const std::vector<int>& vec, std::unordered_set<std::size_t>& indices);
    
    void getMaxRec(const std::vector<int>& vec, std::unordered_set<std::size_t>& indices, std::vector<int>& out, int number);
    
class HighScores {
   private:
    std::vector<int> scores;

   public:
    HighScores(std::vector<int> scores) : scores(scores){};

    std::vector<int> list_scores();

    int latest_score();

    int personal_best();

    std::vector<int> top_three();
};

}  // namespace arcade
