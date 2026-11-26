#include "triangle.h"
#include <stdexcept>
#include <array> 
#include <algorithm>
namespace triangle {
    // Considering floating points values comparison
    bool areEqual(double a, double b, double epsilon) {
        return std::abs(a - b) <= epsilon * std::max(std::abs(a), std::abs(b));
    }
    flavor kind(double a, double b, double c) {
        // Considering using array, but as for me it looks like not the simplifying of condition, but
        // vice versa. 
        std::array<double, 3> sides = {a, b, c};
        if(std::any_of(sides.begin(), sides.end(), [](double side) { return side <= 0; })) {
            throw std::domain_error("Triangles with no size or negative size are illegal");
        }
        if(a + b < c || a + c < b || b + c < a) {
            throw std::domain_error("Triangles violating triangle inequality are illegal");
        }
        if (areEqual(a, b) && areEqual(b, c)) {
            return flavor::equilateral;
        } else if (areEqual(a, b) || areEqual(b, c) || areEqual(a, c)) {
            return flavor::isosceles;
        } else {
            return flavor::scalene;
        }
    }
}  // namespace triangle