#include "power_of_troy.h"

namespace troy {

	void give_new_artifact(human& guy, const std::string& artifact_name)
	{
		guy.possession = std::make_unique<artifact>(artifact_name);
	}
	void exchange_artifacts(std::unique_ptr<artifact>& art1, std::unique_ptr<artifact>& art2)
	{
		std::swap(art1, art2);
	}
	void manifest_power(human& guy, const std::string& pow)
	{
		guy.own_power = std::make_shared<power>(pow);
	}
	void use_power(human& caster, human& recipient)
	{
		recipient.influenced_by = caster.own_power;
	}
	int power_intensity(const human& hero)
	{
		if (hero.own_power == nullptr) {
			return 0;
		}
		else
		{
			return static_cast<int>(hero.own_power.use_count());
		}
	}
}  // namespace troy
