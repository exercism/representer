#pragma once

#include <string>
#include <string_view>

namespace run_length_encoding {

    std::string encode(std::string_view);

    std::string decode(std::string_view);

}  // namespace run_length_encoding
