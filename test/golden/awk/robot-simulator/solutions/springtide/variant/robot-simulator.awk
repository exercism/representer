BEGIN {
    RS = "[[:space:]]+"
    !x || x = 0; !y && y = 0; !dir && dir = "north"
    split("north east south west", dir_names, " ")
    for (i=1; i<=4; i++)
        dir_nums[dir_names[i]] = i
    if ( ! (dir in dir_nums) ) {
        error = "invalid direction"
        exit 1
    }
    split("0 1 0 -1", x_moves, " ")
    split("1 0 -1 0", y_moves, " ")
    compass = dir_nums[dir]
}

/[^ALR]/    { error = "invalid instruction"; exit 1 }
/A/         { x += x_moves[compass]; y += y_moves[compass] }
/R/         { compass++; if (compass > 4) compass = 1 }
/L/         { compass--; if (compass < 1) compass = 4 }

END { print ( error ? error : x " " y " " dir_names[compass] ) }