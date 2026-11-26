#include "largest_series_product.h"
#include <iostream>
#include <vector>
#include <algorithm>
namespace largest_series_product {
    int largest_product(string nums, int span) {
        if (!std::all_of(nums.begin(), nums.end(), [](char c) {return isdigit(c);}))
            throw std::domain_error("All characters must be digits");
        if (span < 0)
            throw std::domain_error("Span must be non-negative");
        if (span > (int) nums.length())
            throw std::domain_error("Span must be shorter than input string");
        std::vector<int> prods;
        int curr_prod;
        
        for (int i = 0; i < (int) nums.length() - span + 1; i++) {
            curr_prod = 1;
            for (char c : nums.substr(i, span))
                curr_prod *= (c - '0');
            prods.push_back(curr_prod);
        }
        return *std::max_element(prods.begin(), prods.end());
    }
} // largest_series_product