const std = @import("std");

pub fn eggCount(number: usize) usize {
    var currentNum = number;
    var sum: usize = 0;
    while(currentNum >= 0){
        sum += currentNum & 1;
        currentNum >>= 1;
    }
    return sum;
}
