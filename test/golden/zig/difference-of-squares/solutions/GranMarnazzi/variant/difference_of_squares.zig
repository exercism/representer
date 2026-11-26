const std = @import("std");

pub fn squareOfSum(number: usize) usize {
    var c: usize = 0;
    for (0..(number - 1)) |n| {
        c += n;
    }
    return c * c;
}

pub fn sumOfSquares(number: usize) usize {
    var c: usize = 0;
    for (0..number + 1) |n| {
        c += n * n;
    }
    return c;
}

pub fn differenceOfSquares(number: usize) usize {
    return squareOfSum(number) - sumOfSquares(number);
}
