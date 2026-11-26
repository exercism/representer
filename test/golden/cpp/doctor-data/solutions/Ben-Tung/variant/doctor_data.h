#include <string>

namespace star_map{
    enum class System{BetaHydri, Sol, EpsilonEridani, AlphaCentauri, DeltaEridani, Omicron2Eridani};
}

namespace heaven{
    class Vessel{
        private:
            
    
        public:

            std::string name{};
            star_map::System current_system{star_map::System::Sol};
            int generation{};
            int busters{0};
                
            Vessel(std::string name, int generation){
                this->name = name;
                this->generation = generation;
            }
            Vessel(std::string name, int generation, star_map::System current_system){
                this->name = name;
                this->generation = generation;
                this->current_system = current_system;
            }
            Vessel replicate(std::string repName){
                //I think returns the stuff to duplicate a Vessel object
                Vessel replication(repName, generation - 1, current_system);
                return replication;
            }
            void make_buster(){
                busters++;
                return;
            }
            bool shoot_buster(){
                if(busters >= 1){
                    busters--;
                    return true;
                }
                else{
                    return false;
                }
            }
    };

    std::string get_older_bob(Vessel one, Vessel two){
        if(one.generation > two.generation){
            return two.name;
        }
        else if(one.generation < two.generation){
            return one.name;
        }
        else{
            return "Equal";
        }
    }
    bool in_the_same_system(Vessel one, Vessel two){
        if(one.current_system == two.current_system){
            return true;
        }
        else{
            return false;
        }
    }
}

