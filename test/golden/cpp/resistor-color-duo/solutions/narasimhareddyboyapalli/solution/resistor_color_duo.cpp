#include "resistor_color_duo.h"
#include <algorithm>
using namespace std;

namespace resistor_color_duo {

    int value(vector<string> colors) {
        string numbers{ "" };

        for (size_t i{ 0 }; i < 2; i++) 
            numbers += to_string(find(table.cbegin(), table.cend(), colors[i])
                                 - table.cbegin());
                    
        return stoi(numbers);
    }

} // namespace resistor_color_duo