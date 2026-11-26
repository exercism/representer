const std = @import("std");
const mem = std.mem;

pub fn isBalanced(allocator: mem.Allocator, s: []const u8) !bool {
    _ = allocator;
    var f: i32 = 0;
    var cur: u31 = 0;
    for(s) |c| {
        switch(c){
            '(' => { cur += 1; f += std.math.pow(i32, 1, cur); },
            '[' => { cur += 2; f += std.math.pow(i32, 2, cur); },
            '{' => { cur += 3; f += std.math.pow(i32, 3, cur); },
            ')' => { f -= std.math.pow(i32, 1, cur); cur -|= 1;},
            ']' => { f -= std.math.pow(i32, 2, cur); cur -|= 2;},
            '}' => { f -= std.math.pow(i32, 3, cur); cur -|= 3;},
            else => continue,
        }
    }
    return f == 0 and cur == 0;
}
