#include "doctor_data.h"
#include <string>

heaven::Vessel::Vessel(std::string newName, int newGeneration, star_map::System newSystem) {
    name = newName;
    generation = newGeneration;
    current_system = newSystem;
}

heaven::Vessel heaven::Vessel::replicate (std::string newName) {
    heaven::Vessel clone(newName, generation-1, current_system);
    return clone;
}

bool heaven::Vessel::shoot_buster (void) {
    if (busters > 0) {
        busters -= 1;
        return true;
    }
    return false;
}

std::string heaven::get_older_bob (Vessel ves1, Vessel ves2) {
    if (ves1.generation < ves2.generation) {
        return ves1.name;
    }
    return ves2.name;
}

bool heaven::in_the_same_system (Vessel ves1, Vessel ves2) {
    if (ves1.current_system == ves2.current_system) {
        return true;
    }
    return false;
}