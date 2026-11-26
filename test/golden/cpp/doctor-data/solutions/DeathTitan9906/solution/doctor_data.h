#pragma once
#include <string>


namespace star_map {

enum class System {
    Sol = 0,
    BetaHydri = 1,
    EpsilonEridani = 2,
    AlphaCentauri = 3,
    DeltaEridani = 4,
    Omicron2Eridani = 5
};
    
} // namespace star_map



namespace heaven {

class Vessel {

public:
    star_map::System current_system;
    int generation;
    int busters = 0;
    std::string name;

    // constructor
    Vessel(std::string newName, int newGeneration, star_map::System newSystem = star_map::System::Sol);

    // mutators
    Vessel replicate (std::string newName);
    void make_buster (void) { busters += 1; }
    bool shoot_buster (void);
    
private:
};

std::string get_older_bob (Vessel ves1, Vessel ves2);
bool in_the_same_system (Vessel ves1, Vessel ves2);

} // namespace heaven
