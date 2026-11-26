#include "queen_attack.h"
#include <stdlib.h>

int out_of_bounds(position_t queen) {
    return queen.column > 7 || queen.row > 7;
}

int on_same_position(position_t queen_1, position_t queen_2) {
    return queen_1.column == queen_2.column && queen_1.row == queen_2.row;
}

attack_status_t can_attack(position_t queen_1, position_t queen_2) {
    if (out_of_bounds(queen_1) || out_of_bounds(queen_2) || on_same_position(queen_1, queen_2))
        return INVALID_POSITION;
    if (
        abs(queen_2.column - queen_1.column) == abs(queen_2.row - queen_1.row) ||
        queen_2.column == queen_1.column ||
        queen_2.row == queen_1.row
       )
        return CAN_ATTACK;
    return CAN_NOT_ATTACK;
}