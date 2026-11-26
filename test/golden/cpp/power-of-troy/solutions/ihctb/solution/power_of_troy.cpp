#include "power_of_troy.h"

namespace troy {
void give_new_artifact(human &person, std::string artifact_name) {
    person.possession = std::make_unique<artifact>(artifact_name);
}

void exchange_artifacts(std::unique_ptr<artifact> &a1,
                        std::unique_ptr<artifact> &a2) {
    std::swap(a1, a2);
}

void manifest_power(human &person, std::string power_name) {
    person.own_power = std::make_shared<power>(power_name);
}

void use_power(human &influencer, human &influenced) {
    influenced.influenced_by = influencer.own_power;
}

int power_intensity(human &person) { return person.own_power.use_count(); }

} // namespace troy
