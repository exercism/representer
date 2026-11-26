#include "queen_attack.h"
#include <stdbool.h>
#include <stdlib.h>

static bool is_valid_position(position_t pos)
{
    return pos.row < 8 && pos.column < 8;
}

attack_status_t can_attack(position_t queen_1, position_t queen_2)
{
    if (!is_valid_position(queen_1) || !is_valid_position(queen_2)) {
        return INVALID_POSITION;
    }
    if (queen_1.row == queen_2.row && queen_1.column == queen_2.column) {
        return INVALID_POSITION;
    }

    int row_diff = abs((int)queen_1.row - (int)queen_2.row);
    int col_diff = abs((int)queen_1.column - (int)queen_2.column);

    if (row_diff == 0 || col_diff == 0 || row_diff == col_diff) {
        return CAN_ATTACK;
    }

    return CAN_NOT_ATTACK;
}
