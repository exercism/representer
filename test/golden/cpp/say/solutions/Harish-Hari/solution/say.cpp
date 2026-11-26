#include "say.h"
#include <stdexcept>
#include <vector>
namespace say {
namespace {
std::string splitNumberIntoChunks(std::int64_t number);
const std::vector<std::string> g_ones = {"zero",  "one",  "two", "three",
                                         "four",  "five", "six", "seven",
                                         "eight", "nine"};
const std::vector<std::string> g_teens = {
    "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
    "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"};
const std::vector<std::string> g_tens = {"zero",   "ten",   "twenty", "thirty",
                                         "forty",  "fifty", "sixty",  "seventy",
                                         "eighty", "ninety"};
using Thousandess = std::vector<std::pair<std::string, std::int64_t>>;
const Thousandess g_thousandness = {{"billion", 1000 * 1000 * 1000},
                                    {"million", 1000 * 1000},
                                    {"thousand", 1000},
                                    {"", 1}};
std::string parseTwoDigits(int number) {
  std::string result{};
  if (number > 19) {
    int tens{number / 10};
    int ones{number % 10};
    result = g_tens.at(tens);
    if (ones != 0) {
      result += '-' + g_ones.at(ones);
    }
  } else {
    result = g_teens.at(number - 10);
  }
  return result;
}
std::string parseBelowThousand(int number) {
  std::string result{};
  if (number > 99) {
    int hundreds{number / 100};
    int remainder{number % 100};
    result = g_ones.at(hundreds) + " hundred";
    if (remainder != 0) {
      result += ' ' + parseTwoDigits(remainder);
    }
  } else if (number > 9) {
    result = parseTwoDigits(number);
  } else {
    result = g_ones.at(number);
  }
  return result;
}
std::string splitNumberIntoChunks(std::int64_t number) {
  std::string result{};
  int chunk{};
  if (number == 0) {
    return "zero";
  }
  for (const auto &element : g_thousandness) {
    if (number >= element.second) {
      chunk = number / element.second;
      number = number % element.second;
      if (chunk != 0) {
        result += parseBelowThousand(chunk) + ' ' + element.first;
        if (number != 0) {
          result += ' ';
        }
      }
    }
  }
  return result.erase(result.find_last_not_of(" \n") + 1);
}
} // namespace
std::string in_english(std::int64_t number) {
  if (number < 0 || number >= static_cast<std::int64_t>(1000ULL * 1000ULL *
                                                        1000ULL * 1000ULL)) {
    throw std::domain_error("Error");
  }
  return splitNumberIntoChunks(number);
}
} // namespace say