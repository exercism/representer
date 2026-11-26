const std = @import("std");
pub const Relation = enum {
    equal,
    sublist,
    superlist,
    unequal,
};

pub fn compare(list_one: []const i32, list_two: []const i32) Relation {
    if(std.mem.eql(i32, list_one, list_two)) {
        return Relation.equal;
    }
    if(isContiguousSubsequence(i32, list_one, list_two)){
        return Relation.sublist;
    }
    if(isContiguousSubsequence(i32, list_two, list_one)){
        return Relation.superlist;
    }
    return Relation.unequal;
    
}

/// Checks if array1 is a contiguous sub-sequence of array2
fn isContiguousSubsequence(comptime T: type, array1: []const T, array2: []const T) bool {
    if (array1.len == 0) return true;
    if (array1.len > array2.len) return false;

    outer: for(0..array2.len - array1.len + 1) |start_idx| {
        for(array1, 0..) |elem, end_idx| {
            if (elem != array2[start_idx + end_idx]) {
                continue :outer;
            }
        }
        return true;
    }
    return false;
}
