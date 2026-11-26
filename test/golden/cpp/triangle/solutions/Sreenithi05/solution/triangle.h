#if !defined(TRIANGLE_H)
#define TRIANGLE_H
#include <cmath>
#include <limits>
namespace triangle {
    enum class flavor {
        equilateral,
        isosceles,
        scalene 
    };
    bool areEqual(double a, double b, double epsilon = std::numeric_limits<double>::epsilon());
    flavor kind(double a, double b, double c);
}  // namespace triangle
#endif // TRIANGLE_H