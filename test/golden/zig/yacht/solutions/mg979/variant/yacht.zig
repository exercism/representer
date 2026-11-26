pub const Category = enum {
    ones,
    twos,
    threes,
    fours,
    fives,
    sixes,
    full_house,
    four_of_a_kind,
    little_straight,
    big_straight,
    choice,
    yacht,
};

pub fn score(dice: [5]u3, category: Category) u32 {
    switch (category) {
        .ones => return ones(dice),
        .twos => return twos(dice),
        .threes => return threes(dice),
        .fours => return fours(dice),
        .fives => return fives(dice),
        .sixes => return sixes(dice),
        .full_house => return full_house(dice),
        .four_of_a_kind => return four_of_a_kind(dice),
        .little_straight => return little_straight(dice),
        .big_straight => return big_straight(dice),
        .choice => return choice(dice),
        .yacht => return yacht(dice),
    }
}

fn ones(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == 1) {
            total += 1;
        }
    }
    return total;
}

fn twos(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == 2) {
            total += 2;
        }
    }
    return total;
}

fn threes(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == 3) {
            total += 3;
        }
    }
    return total;
}

fn fours(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == 4) {
            total += 4;
        }
    }
    return total;
}

fn fives(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == 5) {
            total += 5;
        }
    }
    return total;
}

fn sixes(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (dice) |die| {
        if (die == 6) {
            total += 6;
        }
    }
    return total;
}

fn all_sides(dice: [5]u3) [6]u3 {
    var sides: [6]u3 = undefined;
    @memset(&sides, 0);
    for (dice) |die| {
        sides[die - 1] += 1;
    }
    return sides;
}

fn full_house(dice: [5]u3) u32 {
    const sides = all_sides(dice);
    const triple: u32 = for (sides, 0..) |side, n| {
        if (side == 3) {
            break side_number(n) * 3;
        }
    } else return 0;
    const double: u32 = for (sides, 0..) |side, n| {
        if (side == 2) {
            break side_number(n) * 2;
        }
    } else return 0;
    return triple + double;
}

fn four_of_a_kind(dice: [5]u3) u32 {
    for (all_sides(dice), 0..) |side, n| {
        if (side >= 4) {
            return side_number(n) * 4;
        }
    } else return 0;
}

fn little_straight(dice: [5]u3) u32 {
    const sides = all_sides(dice);
    if (sides[0] == 1
        and sides[1] == 1
        or sides[2] == 1
        and sides[3] == 1
        and sides[4] == 1)
        return 30;
    return 0;
}

fn big_straight(dice: [5]u3) u32 {
    const sides = all_sides(dice);
    if (sides[1] == 1
        and sides[2] == 1
        and sides[3] == 1
        and sides[4] == 1
        and sides[5] == 1)
        return 30;
    return 0;
}

fn choice(dice: [5]u3) u32 {
    var total: u32 = 0;
    for (all_sides(dice), 0..) |side, n| {
        total += side_number(n) * side;
    }
    return total;
}

fn yacht(dice: [5]u3) u32 {
    for (all_sides(dice)) |side| {
        if (side == 5) {
            return 50;
        }
    } else return 0;
}

inline fn side_number(n: usize) u32 {
    return @as(u32, @truncate(n)) + 1;
}
