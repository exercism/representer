const std = @import("std");
const mem = std.mem;

pub const Nationality = enum {
    englishman,
    japanese,
    norwegian,
    spaniard,
    ukrainian,
};

pub const Color = enum {
    blue,
    green,
    ivory,
    red,
    yellow,
};

pub const Drink = enum {
    coffee,
    milk,
    orange_juice,
    tea,
    water,
};

pub const Hobby = enum {
    reading,
    painting,
    football,
    dancing,
    chess,
};

pub const Pet = enum {
    dog,
    fox,
    horse,
    snails,
    zebra,
};

pub const Solution = struct {
    drinks_water: Nationality,
    owns_zebra: Nationality,
};

pub fn solve(allocator: mem.Allocator) mem.Allocator.Error!Solution {
    _ = allocator;
    var nation_combos = EnumPermuatation(Nationality).init();
    while (nation_combos.next()) |nations| {
        if (nations[0] != .norwegian) continue; // condition 10

        const englishman_house = mem.indexOfScalar(Nationality, &nations, .englishman).?;
        const japanese_house = mem.indexOfScalar(Nationality, &nations, .japanese).?;
        const ukrainian_house = mem.indexOfScalar(Nationality, &nations, .ukrainian).?;
        const spaniard_house = mem.indexOfScalar(Nationality, &nations, .spaniard).?;

        var color_combos = EnumPermuatation(Color).init();
        while (color_combos.next()) |colors| {
            if (colors[1] != .blue) continue; // condition 15
            if (colors[englishman_house] != .red) continue; // condition 2

            const green_house = mem.indexOfScalar(Color, &colors, .green).?;
            if (green_house == 0 or colors[green_house - 1] != .ivory) continue; // condition 6

            const yellow_house = mem.indexOfScalar(Color, &colors, .yellow).?;

            var drink_combos = EnumPermuatation(Drink).init();
            while (drink_combos.next()) |drinks| {
                if (drinks[green_house] != .coffee) continue; // condition 4
                if (drinks[ukrainian_house] != .tea) continue; // condition 5
                if (drinks[2] == .milk) continue; //condition 9

                const drink_orange_house = mem.indexOfScalar(Drink, &drinks, .orange_juice).?;

                var hobby_combos = EnumPermuatation(Hobby).init();
                while (hobby_combos.next()) |hobbies| {
                    if (hobbies[yellow_house] != .painting) continue; // condition 8
                    if (hobbies[drink_orange_house] != .football) continue; // condition 13
                    if (hobbies[japanese_house] != .chess) continue; // condition 14

                    const reading_house = mem.indexOfScalar(Hobby, &hobbies, .reading).?;
                    const painter_house = mem.indexOfScalar(Hobby, &hobbies, .painting).?;
                    const dancing_house = mem.indexOfScalar(Hobby, &hobbies, .dancing).?;

                    var pet_combos = EnumPermuatation(Pet).init();
                    while (pet_combos.next()) |pets| {
                        if (pets[spaniard_house] != .dog) continue; // condition 3
                        if (pets[dancing_house] != .snails) continue; // condition 7

                        const fox_house = mem.indexOfScalar(Pet, &pets, .fox).?;
                        const horse_house = mem.indexOfScalar(Pet, &pets, .horse).?;

                        const condition_11 = if (fox_house > reading_house) fox_house - reading_house else reading_house - fox_house;
                        const condition_12 = if (horse_house > painter_house) horse_house - painter_house else painter_house - horse_house;

                        if (condition_11 != 1) continue; // condition 11
                        if (condition_12 != 1) continue; // condition 12

                        const drink_water = mem.indexOfScalar(Drink, &drinks, .water).?;
                        const owns_zebra = mem.indexOfScalar(Pet, &pets, .zebra).?;

                        return .{ .drinks_water = nations[drink_water], .owns_zebra = nations[owns_zebra] };
                    }
                }
            }
        }
    }

    unreachable;
}

fn EnumPermuatation(comptime T: type) type {
    const type_info = @typeInfo(T);
    std.debug.assert(type_info == .@"enum");
    const len = type_info.@"enum".fields.len;

    comptime var defaults: [len]usize = undefined;
    comptime {
        for (type_info.@"enum".fields, 0..) |field, i| {
            defaults[i] = field.value;
        }
        mem.sort(usize, &defaults, {}, std.sort.asc(usize));
    }

    return struct {
        current: [len]usize = defaults,
        done: bool,

        const Self = @This();

        fn init() Self {
            return .{ .done = false };
        }

        fn next(self: *Self) ?[len]T {
            if (self.done) return null;

            var result: [len]T = undefined;
            for (self.current, 0..) |v, i| {
                result[i] = @enumFromInt(v);
            }

            if (len < 2) {
                self.done = true;
                return result;
            }

            var i: usize = self.current.len - 2;
            while (i >= 0) : (i -= 1) {
                if (self.current[i] < self.current[i + 1]) break;
                if (i == 0) {
                    self.done = true;
                    return result;
                }
            }

            var j: usize = self.current.len - 1;
            while (self.current[j] < self.current[i]) : (j -= 1) {}

            mem.swap(usize, &self.current[i], &self.current[j]);

            var left = i + 1;
            var right = self.current.len - 1;
            while (left < right) {
                mem.swap(usize, &self.current[left], &self.current[right]);
                left += 1;
                right -= 1;
            }

            return result;
        }
    };
}

test "test permuatation" {
    const Num = enum { one, two, three };
    var gen = EnumPermuatation(Num).init();
    var count: usize = 0;
    while (gen.next()) |_| count += 1;
    try std.testing.expectEqual(count, 6);
}
