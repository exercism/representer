#include "list_ops.h"
namespace list_ops {
    void append(std::vector<int>& left, const std::vector<int>& right) {
        for (auto r : right) {
            left.push_back(r);
        }
    }
    std::vector<int> concat(std::vector<std::vector<int>>& input) {
        std::vector<int> result;
        for (auto outer : input) {
            for (auto n : outer) {
                result.push_back(n);
            }
        }
        return result;
    }
    std::vector<std::vector<int>> concat(std::vector<std::vector<std::vector<int>>>& input) {
        std::vector<std::vector<int>> result;
        for (auto outer : input) {
            for (auto n : outer) {
                result.push_back(n);
            }
        }
        return result;
    }
    std::vector<int> filter(std::vector<int>& input, std::function<bool(int)> lambda_func) {
        std::vector<int> result;
        for (auto i : input) {
            if (lambda_func(i)) {
                result.push_back(i);
            }
        }
        return result;
    }
    size_t length(const std::vector<int>& input) {
        return input.size();
    }
    std::vector<int> map(std::vector<int>& input, std::function<int(int)> lambda_func) {
        std::vector<int> result;
        for (auto i : input) {
            result.push_back(lambda_func(i));
        }
        return result;
    }
    int foldl(std::vector<int>& input, int acc, std::function<int(int, int)> lambda_func) {
        int result = acc;
        for (auto it = input.begin(); it != input.end(); it++) {
            result = lambda_func(result, *it);
        }
        return result;
    }
    double foldl(std::vector<double>& input, double acc, std::function<double(double, double)> lambda_func) {
        double result = acc;
        for (auto it = input.begin(); it != input.end(); it++) {
            result = lambda_func(result, *it);
        }
        return result;
    }
    int foldr(std::vector<int>& input, int acc, std::function<int(int, int)> lambda_func) {
        int result = acc;
        for (auto it = input.rbegin(); it != input.rend(); it++) {
            result = lambda_func(result, *it);
        }
        return result;
    }
    double foldr(std::vector<double>& input, double acc, std::function<double(double, double)> lambda_func) {
        double result = acc;
        for (auto it = input.rbegin(); it != input.rend(); it++) {
            result = lambda_func(result, *it);
        }
        return result;
    }
    std::vector<int> reverse(std::vector<int>& input) {
        std::vector<int> result(input.rbegin(), input.rend());
        return result;
    }
    std::vector<std::vector<int>> reverse(std::vector<std::vector<int>>& input) {
        std::vector<std::vector<int>> result(input.rbegin(), input.rend());
        return result;
    }
}  // namespace list_ops