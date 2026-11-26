#include "say.h"
#include <string>
#include <stdexcept>
#include <vector>
using namespace std;

namespace say {
  string dictionary(string key, int num) {
    const string units[10] = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};
    const string teens[10] = {"ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"};
    const string tens[8] = {"twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"};
    const string groups[4] = {"billion", "million", "thousand"}; // ? set to 4 so the last group will be empty string rather than grab unwanted value

    if (key == "unit") return units[num];
    if (key == "teen") return teens[num - 10];
    if (key == "ten") return tens[num - 2];
    if (key == "group") return groups[num];
    return "";
  }

  string to_word(int num) {
    string result;
    int hundred = num / 100;
    int tens = (num - (hundred * 100)) / 10;

    if ((hundred) != 0) {
      result += (dictionary("unit", hundred) + " hundred ");
    }

    if ((tens) != 0) {
      if (tens == 1) {
        result += dictionary("teen", num - (hundred * 100));
      } else if (tens > 1) {
        int unit = num - ((hundred * 100) + (tens * 10));
        result += dictionary("ten", tens);
        if (unit > 0) result += ("-" + dictionary("unit", unit));
      }
    }

    if (num > 0 && num < 10) result += dictionary("unit", num);

    return result;
  }

  vector<string> group_num_in_words(unsigned long long int num) {
    string series = to_string(num);
    vector<string> groups = {};
    int s_size = series.size();
    int breakpoint = s_size % 3;

    if (breakpoint != 0) {
      int number = stoi(series.substr(0, breakpoint));
      groups.push_back(to_word(number));
    }

    for (int i = breakpoint; i < s_size; i += 3) {
      int number = stoi(series.substr(i, 3));
      groups.push_back(to_word(number));
    }

    return groups;
  }

  string in_english(unsigned long long int num) {
    if (num == 0) return dictionary("unit", num);

    if (num > 999'999'999'999) {
      throw domain_error("Unrecognized input");
    }
      
    vector<string> groups = group_num_in_words(num);
    string result;
    int g_size = groups.size();
    for (int i = 0; i < g_size; i++) {
      auto word = dictionary("group", 4 - g_size + i);

      if (word != "" && groups[i] != "") {
        result += (groups[i] + " " + word + " ");
      } 
      if (word == "" && groups[i] != "") {
        result += (groups[i]);
      }
    }
    if (result.back() == ' ') result.pop_back();
    return result;
  }
}  // namespace say
