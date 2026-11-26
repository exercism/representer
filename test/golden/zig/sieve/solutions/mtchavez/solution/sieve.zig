const std = @import("std");

pub fn primes(buffer: []u32, limit: u12) []u32 {
    // if (limit < 2) {
    //     return &[_]u32{};
    // }
    // if (limit == 2) {
    //     buffer[0] = 2;
    //     return buffer[0..1];
    // }
    // // var found: [limit]u32 = undefined;
    // //
    // // // Fill the entire buffer with the value 42
    // // @memset(&found, 1);
    // // const allocator = std.heap.page_allocator;
    // // var found: std.ArrayList(u32) = .empty;
    // @memset(buffer, 1);
    // // std.debug.print("Buffer initialized for limit {d}\n{any}\n", .{ limit, buffer });
    // var next_prime: u32 = 2;
    // for (2..limit + 1) |idx| {
    //     const num = @as(u32, @intCast(idx));
    //     if (buffer[num] == 1) {
    //         std.debug.print("Checking number {d}\n", .{idx});
    //         buffer[next_prime] = num;
    //         next_prime += 1;
    //         var multiple = num * 2;
    //         // std.debug.print("Marking multiples of {d}", .{num});
    //         while (multiple < limit) : (multiple += num) {
    //             // std.debug.print("  Marking {d} as non-prime", .{multiple});
    //             buffer[multiple] = 0;
    //         }
    //     }
    // }
    // std.debug.print("Prime buffer for limit {d}\n{any}\n", .{ limit, buffer });
    // // for (buffer[2..limit], 2..limit) |is_prime, num| {
    // //     if (is_prime != 1) {
    // //         buffer[num] = num;
    // //         // found.append(allocator, @as(u32, @intCast(num))) catch unreachable;
    // //     }
    // // }
    // // return found.toOwnedSlice(allocator) catch unreachable;
    // return buffer[2..next_prime];
    if (limit < 2) {
        return buffer[0..0];
    }

    // Create a boolean sieve array (on stack or use allocator)
    var sieve: [4096]bool = undefined; // u12 max is 4095
    @memset(sieve[0 .. limit + 1], true);

    sieve[0] = false;
    sieve[1] = false;

    var i: usize = 2;
    while (i * i <= limit) : (i += 1) {
        if (sieve[i]) {
            // Mark multiples of i as composite
            var multiple = i * i; // Start from i*i (optimization)
            while (multiple <= limit) : (multiple += i) {
                sieve[multiple] = false;
            }
        }
    }

    // Collect primes into buffer
    var count: usize = 0;
    i = 2;
    while (i <= limit) : (i += 1) {
        if (sieve[i]) {
            buffer[count] = @intCast(i);
            count += 1;
        }
    }

    return buffer[0..count];
}
