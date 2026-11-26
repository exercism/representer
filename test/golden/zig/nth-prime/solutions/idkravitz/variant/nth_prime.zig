const std = @import("std");
const mem = std.mem;

pub fn prime(allocator: mem.Allocator, number: usize) !usize {
    var primes = try std.ArrayList(usize).initCapacity(allocator, number);
    defer primes.deinit(allocator);
    var candidate: usize = 2;
    main_test: while (primes.items.len < number) : (candidate += 1){
        for (primes.items) |p| {
            if (p * p >= candidate) break;
            if (candidate % p == 0) {
                continue :main_test;
            }
        }
        try primes.append(allocator, candidate);
    }
    return primes.items[number - 1];
}
