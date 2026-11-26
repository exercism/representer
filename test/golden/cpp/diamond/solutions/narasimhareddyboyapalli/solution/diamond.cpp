#include "diamond.h"
#include <string>
#include <vector>

namespace diamond {

std::vector<std::string> rows(char letter) {
    if (letter < 'A' || letter > 'Z') {
        return {};
    }

    int size = letter - 'A';  // Determine the size of the diamond
    int width = size * 2 + 1; // The width of the diamond
    
    std::vector<std::string> lines;
    
    // Generate the top half (and middle)
    for (int i = 0; i <= size; ++i) {
        char current_letter = 'A' + i;
        std::string line(width, ' ');
        line[size - i] = current_letter;
        line[size + i] = current_letter;
        lines.push_back(line);
    }
    
    // Generate the bottom half by mirroring the top half
    for (int i = size - 1; i >= 0; --i) {
        lines.push_back(lines[i]);
    }
    
    return lines;
}

}  // namespace diamond