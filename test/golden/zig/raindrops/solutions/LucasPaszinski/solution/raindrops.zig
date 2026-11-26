const fmt = @import("std").fmt;

pub fn convert(buffer: []u8, n: u32) []const u8 {
    const is_pling = (n % 3) == 0;
    const is_plang = (n % 5) == 0;
    const is_plong = (n % 7) == 0;

    return if (is_pling or is_plang or is_plong) fmt.bufPrint(buffer, "{s}{s}{s}", .{
        if (is_pling) "Pling" else "",
        if (is_plang) "Plang" else "",
        if (is_plong) "Plong" else "",
    }) catch unreachable else fmt.bufPrint(buffer, "{}", .{n}) catch unreachable;
}
