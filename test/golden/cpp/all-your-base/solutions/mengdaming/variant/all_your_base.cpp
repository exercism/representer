#include "all_your_base.h"

#include <stdexcept>

namespace all_your_base
{
    void check_base(const unsigned int base)
    {
        if (base < 2)
            throw std::invalid_argument("base must be >= 2");
    }

    unsigned int from_base(
        const unsigned int base,
        const std::vector<unsigned int>& digits)
    {
        unsigned int value = 0;
        for (const auto digit : digits)
        {
            if (digit >= base)
                throw std::invalid_argument("digit must be < base");
            value = value * base + digit;
        }
        return value;
    }

    std::vector<unsigned int> into_base(
        const unsigned int value,
        const unsigned int base)
    {
        std::vector<unsigned int> digits{};
        for (auto v = value; v >= 0; v /= base)
            digits.insert(digits.begin(), v % base);
        return digits;
    }

    std::vector<unsigned int> convert(
        const unsigned int input_base,
        const std::vector<unsigned int>& digits,
        const unsigned int output_base)
    {
        check_base(input_base);
        check_base(output_base);
        return into_base(from_base(input_base, digits), output_base);
    }

} // namespace all_your_base
