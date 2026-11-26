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
    var nums: [6]u32 = [_]u32{0, 0, 0, 0, 0, 0};
    var sum: u32 = 0;
    for (dice) |d| {
        nums[d - 1] += 1;
        sum += @as(u32, d);
    }
    return switch (category) {
        .ones, .twos, .threes, .fours, .fives, .sixes => {
            const d = @intFromEnum(category);
            return nums[d] * (d + 1);
        },
        .full_house => {
            for (nums) |n|
                if (n != 0 and n != 2 and n != 3) { return 0; };
            return sum;
        },
        .four_of_a_kind => {
            for (nums, 1..) |n, d|
                if (n >= 4) { return @as(u32, @truncate(d)) << 2; };
            return 0;
        },
        .little_straight, .big_straight => {
            const s = @intFromEnum(category) - 8;
            for (nums[s..s + 5]) |n|
                if (n != 1) { return 0; }; 
            return 30;
        },
        .choice => sum,
        .yacht => {
            for (nums) |n|
                if (n == 5) { return 50; };
            return 0;
        },
    };
}
