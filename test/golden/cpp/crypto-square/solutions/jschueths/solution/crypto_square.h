#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <algorithm>
#include <cctype>
#include <cmath>
#include <string>
#include <type_traits>
#include <vector>

namespace crypto_square {

namespace detail {

template<class Container, class OutputIterator, class Op>
OutputIterator transform(Container c, OutputIterator out, Op op) {
    return std::transform(std::begin(c), std::end(c), out, op);
}

template<class Container, class Op>
void erase_if(Container& c, Op op) {
    c.erase(std::remove_if(std::begin(c), std::end(c), op), c.end());
}

inline std::vector<std::string> chunk(std::string str, int size) {
    std::vector<std::string> result;
    while(!str.empty()) {
        result.emplace_back(str.substr(0, size));
        str.erase(0, size);
    }
    return result;
}

template <class C>
constexpr auto ssize(const C& c) 
    -> std::common_type_t<std::ptrdiff_t,
                          std::make_signed_t<decltype(c.size())>> 
{
    using R = std::common_type_t<std::ptrdiff_t,
                                 std::make_signed_t<decltype(c.size())>>;
    return static_cast<R>(c.size());
}

} // namespace detail

class cipher {
    public:
        cipher(std::string str) : m_str(std::move(str)) {}

        std::string normalize_plain_text() const {
            std::string result;
            detail::transform(m_str, std::back_inserter(result), [](unsigned char c) {
                return std::tolower(c);
            });
            detail::erase_if(result, [](unsigned char c) {
                return std::ispunct(c) || std::isspace(c);
            });
            return result;
        }

        std::string cipher_text() const {
            auto result = normalized_cipher_text();
            detail::erase_if(result, [](unsigned char c) {
                return std::isspace(c);
            });
            return result;
        }

        std::string normalized_cipher_text() const {
            auto square = plain_text_segments();
            if(!square.empty()) {
                auto size = square.front().size();
                detail::transform(square, square.begin(), [=](std::string s) {
                    while(s.size() < size) {
                        s.push_back(' ');
                    }
                    return s;
                });
                std::string result;
                for(int i = 0; i < detail::ssize(square.front()); ++i) {
                    if(i > 0) {
                        result.push_back(' ');
                    }
                    for(int j = 0; j < detail::ssize(square); ++j) {
                        result.push_back(square[j][i]);
                    }
                }
                return result;
            }
            return "";
        }

        std::vector<std::string> plain_text_segments() const {
            auto normalized = normalize_plain_text();
            int c = std::sqrt(static_cast<int>(normalized.size()));
            if((c * c) != static_cast<int>(normalized.size())) {
                c++;
            }
            if(c > 0) {
                return detail::chunk(std::move(normalized), c);
            }
            return {};
        }

    private:
        std::string m_str;
};

}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H
