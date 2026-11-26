#pragma once
#include <functional>
#include <vector>
namespace list_ops {
    void append(std::vector<int>&, const std::vector<int>&);
    std::vector<int> concat(std::vector<std::vector<int>>&);
    std::vector<std::vector<int>> concat(std::vector<std::vector<std::vector<int>>>&);
    std::vector<int> filter(std::vector<int>&, std::function<bool(int)>);
    size_t length(const std::vector<int>&);
    std::vector<int> map(std::vector<int>&, std::function<int(int)>);
    int foldl(std::vector<int>&, int, std::function<int(int, int)>);
    double foldl(std::vector<double>&, double, std::function<double(double, double)>);
    int foldr(std::vector<int>&, int, std::function<int(int, int)>);
    double foldr(std::vector<double>&, double, std::function<double(double, double)>);
    std::vector<int> reverse(std::vector<int>&);
    std::vector<std::vector<int>> reverse(std::vector<std::vector<int>>&);
}  // namespace list_ops