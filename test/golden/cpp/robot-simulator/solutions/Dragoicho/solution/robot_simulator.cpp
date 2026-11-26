#include "robot_simulator.h"


namespace robot_simulator {

    std::map<Bearing, int> bearing_int_map {
        {Bearing::NORTH, 0},
        {Bearing::EAST, 1},
        {Bearing::SOUTH, 2},
        {Bearing::WEST, 3}
    };

    std::map<int, Bearing> int_bearing_map {
        {0, Bearing::NORTH},
        {1, Bearing::EAST},
        {2, Bearing::SOUTH},
        {3, Bearing::WEST}
    };

    std::pair<int, int> Robot::get_position() const {
        return Robot::position;
    }

    Bearing Robot::get_bearing() const {
        return Robot::bearing;
    }

    void Robot::turn_right() {
        int bearing_number = robot_simulator::bearing_int_map[Robot::bearing];
        bearing_number = (bearing_number + 1) % 4;
        Robot::bearing = robot_simulator::int_bearing_map[bearing_number];
    }

    void Robot::turn_left() {
        int bearing_number = robot_simulator::bearing_int_map[Robot::bearing];
        bearing_number = bearing_number - 1;
        if (bearing_number == -1) bearing_number = 3;
        Robot::bearing = robot_simulator::int_bearing_map[bearing_number];
    }

    void Robot::advance() {
        switch (Robot::bearing) {
            case robot_simulator::Bearing::NORTH:
                Robot::position.second += 1;
                break;
            case robot_simulator::Bearing::EAST:
                Robot::position.first += 1;
                break;
            case robot_simulator::Bearing::SOUTH:
                Robot::position.second -= 1;
                break;
            case robot_simulator::Bearing::WEST:
                Robot::position.first -= 1;
                break;
        } // switch
    } // advance()

    void Robot::execute_sequence(std::string commands) {
        for (char command: commands) {
            switch (command) {
                case 'R':
                    Robot::turn_right();
                    break;
                case 'L':
                    Robot::turn_left();
                    break;
                case 'A':
                    Robot::advance();
                    break;
            } // switch
        } // for
    } // execute_sequence()

} // namespace robot_simulator
