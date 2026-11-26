#include "allergies.h"

namespace allergies {
	const std::map<int, std::string> allergy_test::allergenCodes = {
		{ 0b00000001, "eggs" },
		{ 0b00000010, "peanuts" },
		{ 0b00000100, "shellfish" },
		{ 0b00001000, "strawberries" },
		{ 0b00010000, "tomatoes" },
		{ 0b00100000, "chocolate" },
		{ 0b01000000, "pollen" },
		{ 0b10000000, "cats" }
	};

	allergy_test::allergy_test(int score) {
		for (auto const& allergen : allergenCodes) {
			if (score & allergen.first) {
				allergyList.emplace(allergen.second);
			}
		}
	}

	bool allergy_test::is_allergic_to(std::string query) {
		return allergyList.find(query) != allergyList.end();
	}
}  // namespace allergies
