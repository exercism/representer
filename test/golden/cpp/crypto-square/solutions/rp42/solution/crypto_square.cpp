#include "crypto_square.h"

#include <algorithm>
#include <iterator>
#include <cctype>
#include <cmath>

namespace crypto_square {

cipher::cipher(const std::string & in) {
    for (const auto & c : in) {
        if (std::isalnum(c)) {
            normalised += std::tolower(c);
        }
    }
}

std::vector<std::string> cipher::plain_text_segments() const {
    auto root_len = std::sqrt(normalised.size());
    auto rows = static_cast<int>(root_len);
    auto cols = (std::fmod(root_len, 1.0) == 0.0) ? rows : rows + 1;

    std::vector<std::string> rv;
    auto it = normalised.cbegin();
    while (it != normalised.cend()) {
        auto remain = static_cast<int>(std::distance(it, normalised.cend()));
        auto end = it + std::min(cols, remain);
        rv.emplace_back(it, end);
        it = end;
    }

    return rv;
}

std::string cipher::cipher_text_impl(bool normalize) const {
    auto segs = plain_text_segments();

    std::string rv;
    if (!segs.empty()) {
        auto cols = segs.at(0).size();
        for (auto i = 0U; i < cols; ++i) {
            for (const auto & s : segs) {
                if (i < s.size())
                    rv +=  s.at(i);
                else if (normalize)
                    rv += ' ';
            }
            if (normalize && i != cols - 1) {
                rv += ' ';
            }
        }
    }

    return rv;
}

}  // namespace crypto_square
