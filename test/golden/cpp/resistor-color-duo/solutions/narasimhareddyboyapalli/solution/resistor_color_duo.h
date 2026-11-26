#pragma once
#include <string>
#include <vector>

namespace resistor_color_duo {

    const std::vector<std::string> table{ "black",  "brown", "red",  "orange",
                                          "yellow", "green", "blue", "violet",
                                          "grey",   "white" };
    int value(std::vector<std::string>);

} // namespace resistor_color_duo