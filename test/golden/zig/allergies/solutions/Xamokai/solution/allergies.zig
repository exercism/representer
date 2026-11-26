const std = @import("std");
const EnumSet = std.EnumSet;

pub const Allergen = enum (usize){
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
   return @intFromEnum(allergen) & score == @intFromEnum(allergen);
}

pub fn initAllergenSet(score: usize) EnumSet(Allergen) {
    var allergens: EnumSet(Allergen) = .{};
    inline for(0..8) |i| {
        const field: Allergen = @enumFromInt(1 << i);
        if(isAllergicTo(@truncate(score), field))
            allergens.insert(field);
    }
    return allergens;
}
