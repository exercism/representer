const std = @import("std");
const mem = std.mem;

pub const SayError = error{
    OutOfRange,
};

const below_20 = [_][]const u8{
    "zero", "one",    "two",    "three",    "four",     "five",    "six",     "seven",     "eight",    "nine",
    "ten",  "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen",
};

const tens_words = [_][]const u8{
    "", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
};

const scales = [_][]const u8{
    "", "thousand", "million", "billion",
};

fn sayBelow100(allocator: mem.Allocator, n: u64) (mem.Allocator.Error)![]u8 {
    if (n == 0) return allocator.dupe(u8, "");
    if (n < 20) return allocator.dupe(u8, below_20[n]);

    const t = n / 10;
    const o = n % 10;

    if (o == 0) return allocator.dupe(u8, tens_words[t]);

    return std.fmt.allocPrint(allocator, "{s}-{s}", .{ tens_words[t], below_20[o] });
}

fn sayBelow1000(allocator: mem.Allocator, n: u64) (mem.Allocator.Error)![]u8 {
    if (n == 0) return allocator.dupe(u8, "");
    if (n < 100) return sayBelow100(allocator, n);

    const h = n / 100;
    const rest = n % 100;

    if (rest == 0) return std.fmt.allocPrint(allocator, "{s} hundred", .{below_20[h]});

    const rest_str = try sayBelow100(allocator, rest);
    defer allocator.free(rest_str);

    return std.fmt.allocPrint(allocator, "{s} hundred {s}", .{ below_20[h], rest_str });
}

pub fn say(allocator: mem.Allocator, number: i41) (mem.Allocator.Error || SayError)![]u8 {
    if (number < 0 or number >= 1_000_000_000_000) return SayError.OutOfRange;

    const n: u64 = @intCast(number);

    if (n == 0) return allocator.dupe(u8, "zero");

    var parts: [4]?[]const u8 = .{ null, null, null, null };
    var part_count: usize = 0;

    var scale_idx: usize = 0;
    var n_copy = n;

    while (n_copy > 0) : ({
        n_copy /= 1000;
        scale_idx += 1;
    }) {
        const chunk = n_copy % 1000;
        if (chunk > 0) {
            const chunk_str = sayBelow1000(allocator, chunk) catch |err| {
                for (0..part_count) |i| {
                    allocator.free(parts[i].?);
                }
                return err;
            };

            if (scale_idx > 0) {
                const with_scale = std.fmt.allocPrint(allocator, "{s} {s}", .{ chunk_str, scales[scale_idx] }) catch |err| {
                    allocator.free(chunk_str);
                    for (0..part_count) |i| {
                        allocator.free(parts[i].?);
                    }
                    return err;
                };
                allocator.free(chunk_str);
                parts[part_count] = with_scale;
            } else {
                parts[part_count] = chunk_str;
            }
            part_count += 1;
        }
    }

    var result = try std.ArrayList(u8).initCapacity(allocator, 0);
    errdefer {
        for (0..part_count) |i| {
            if (parts[i]) |p| allocator.free(p);
        }
        result.deinit(allocator);
    }

    var i: usize = part_count;
    while (i > 0) {
        i -= 1;
        if (result.items.len > 0) try result.append(allocator, ' ');
        try result.appendSlice(allocator, parts[i].?);
        allocator.free(parts[i].?);
        parts[i] = null;
    }

    return result.toOwnedSlice(allocator);
}
