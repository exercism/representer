const std = @import("std");
const EnumSet = std.EnumSet;

pub const Allergen = enum(u8) {
    eggs = 1,
    peanuts = 2,
    shellfish = 4,
    strawberries = 8,
    tomatoes = 16,
    chocolate = 32,
    pollen = 64,
    cats = 128,
};

pub fn isAllergicTo(score: u8, allergen: Allergen) bool {
    const allergenSet = initAllergenSet(score);
    return allergenSet.contains(allergen);
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var allergen_set: EnumSet(Allergen) = EnumSet(Allergen).init(.{});
    var tmp_score = score % 256;
    if (tmp_score >= 0) {
        const enum_fields = std.meta.fields(Allergen);
        comptime var i: usize = enum_fields.len - 1;
        inline while (i >= 0) : (i -= 1) {
            const item_value: usize = enum_fields[i].value;
            if (tmp_score >= item_value) {
                allergen_set.insert(@intToEnum(Allergen, item_value));
                tmp_score -= item_value;
            }
            if (tmp_score == 0 or i == 0) break;
        }
    }
    return allergen_set;
}