#include "matching_brackets.h"
using namespace std;

namespace matching_brackets {
	map<char, char> bracket_pairs = {
		{ '[', ']'},
		{ '{', '}'},
		{ '(', ')'}
	};


	bool check(string text) {
		int opening_count = 0;
		int closing_count = 0;
		for (auto i = text.begin(); i < text.end(); i++) {
			char c = *i;
			for (const auto& [key, value] : bracket_pairs) {
				if (c == value) {
					closing_count++;
					continue;
				}
			}
			if (bracket_pairs.find(c) == bracket_pairs.end()) {
				continue;
			}
			opening_count++;

			int unclosed_pair_count = 0;
			bool found_pair = false;
			for (auto j = i + 1; j < text.end(); j++) {
				char c_check = *j;
				bool skip_iteration = false;
				for (const auto& [key, value] : bracket_pairs) {
					if (c_check == key) {
						unclosed_pair_count++;
						break;
					}
					else if (c_check == value) {
						if (unclosed_pair_count > 0) {
							unclosed_pair_count--;
							skip_iteration = true;
							break;
						}
					}
				}
				if (skip_iteration) {
					continue;
				}
				for (const auto& [key, value] : bracket_pairs) {
					if (c == key && c_check == value) {
						found_pair = true;
						break;
					}
				}
				if (found_pair) {
					break;
				}
			}
			if (!found_pair) {
				return false;
			}
		}
		if (opening_count != closing_count) {
			return false;
		}
		return true;
	}
}  // namespace matching_brackets
