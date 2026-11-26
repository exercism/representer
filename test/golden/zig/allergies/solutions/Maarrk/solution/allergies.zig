const std = @import("std");
const EnumSet = std.EnumSet;

pub const Allergen = enum {
    eggs,
    peanuts,
    shellfish,
    strawberries,
    tomatoes,
    chocolate,
    pollen,
    cats,
};

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    return (score & @as(u8, 1) << @enumToInt(allergen)) != 0;
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var set = EnumSet(Allergen).initFull();
    set.toggleAll();

    var i: u6 = 0;
    while (i < 8) {
        if ((score & @as(usize, 1) << i) != 0) {
            set.bits.setValue(i, true);
        }
        i += 1;
    }
    return set;
}
