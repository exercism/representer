const std = @import("std");

pub const Allergen = enum(u8) {
    eggs = 1 << 0,
    peanuts = 1 << 1,
    shellfish = 1 << 2,
    strawberries = 1 << 3,
    tomatoes = 1 << 4,
    chocolate = 1 << 5,
    pollen = 1 << 6,
    cats = 1 << 7,
};

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    return score & @enumToInt(allergen) != 0;
}

pub fn initAllergenSet(score: usize) std.EnumSet(Allergen) {
    var set = std.EnumSet(Allergen){};
    inline for (std.meta.fields(Allergen)) |field| {
        const allergen = @intToEnum(Allergen, field.value);
        if (isAllergicTo(@truncate(u8, score), allergen)) set.insert(allergen);
    }
    return set;
}