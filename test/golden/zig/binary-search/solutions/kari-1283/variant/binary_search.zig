const std = @import("std");

pub fn binarySearch(T: type, target: T, items: []const T) ?usize {
    if (items.len == 0) return null;
    if (items.len == 1) return 0;

    const sorted: []T = @constCast(items);

    std.mem.sort(T, sorted, {}, std.sort.asc(T));

    if (sorted[0] > target) return null;
    if (sorted[sorted.len - 1] < target) return null;

    var left: usize = 0;
    var right = sorted.len;

    while (left < right) {
        const midpoint = (right - left) / 2;

        if (sorted[midpoint] == target) {
            return midpoint;
        } else if (sorted[midpoint] < target) {
            left = midpoint + 1;
        } else if (sorted[midpoint] > target) {
            right = midpoint;
        }
    }

    return null;
}
