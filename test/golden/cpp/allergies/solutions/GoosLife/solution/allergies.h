#if !defined(ALLERGIES_H)
#define ALLERGIES_H

#include <map>
#include <string>
#include <unordered_set>

namespace allergies {
	class allergy_test {
	private:
		static const std::map<int, std::string> allergenCodes;
		std::unordered_set<std::string> allergyList;

	public:
		allergy_test(int);
		bool is_allergic_to(std::string);
		const std::unordered_set<std::string>& get_allergies() const { return allergyList; }
	};
}  // namespace allergies

#endif // ALLERGIES_H