#pragma once

#include <map>
#include <string>
#include <utility>


namespace robot_simulator {

    enum class Bearing {
        NORTH,
        EAST,
        SOUTH,
        WEST
    };

    class Robot {
        private:
        
        public:
            int x;
            int y;
            std::pair<int, int> position;
            Bearing bearing;
            
            Robot(std::pair<int, int> init_coords={0, 0}, Bearing init_bearing=Bearing::NORTH) {
                x = init_coords.first;
                y = init_coords.second;
                position = init_coords;
                bearing = init_bearing;
            };

            std::pair<int, int> get_position() const;
            Bearing get_bearing() const;
            
            void turn_right();
            void turn_left();
            void advance();
            void execute_sequence(std::string);
    };

}  // namespace robot_simulator
