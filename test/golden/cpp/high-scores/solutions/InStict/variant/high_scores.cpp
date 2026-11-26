#include "high_scores.h"
#include<limits>

#include <algorithm>

namespace arcade {

    int getMax(const std::vector<int>& vec, std::unordered_set<std::size_t>& indices)
{
    int max = -200;
    std::size_t currentIndex = 0;
    for(std::size_t i=0;i<vec.size();i++)
    {
        if(indices.find(i)!=indices.end() && vec[i]>=max)
        {
            max = vec[i];
            currentIndex = i;
        }
    }
    indices.emplace(currentIndex);
    return max;
}

void getMaxRec(const std::vector<int>& vec, std::unordered_set<std::size_t>& indices, std::vector<int>& out, int number)
{
    if(number<1) return;
    out.push_back(getMax(vec, indices));
    number--;
    getMaxRec(vec, indices, out, number);
}

    std::vector<int> HighScores::list_scores()
    {
        return scores;
    }

    int HighScores::latest_score()
    {
        return scores.back();
    }

    int HighScores::personal_best()
    {
        std::unordered_set<std::size_t>index;
        return getMax(scores, index);
    }


    std::vector<int> HighScores::top_three() {
    std::vector<int> result;
        std::unordered_set<std::size_t> indices;
        
std::size_t size = scores.size();
if(size>3){size = 3;}  result.reserve(size);
        getMaxRec(scores, indices,result,size);

        return result;
        
    }

}  // namespace arcade
