const std = @import("std");
const mem = std.mem;

pub const AffineCipherError = error{
    NotCoprime,
};

const m:u8 = 26;

/// Encodes `phrase` using the affine cipher. Caller owns the returned memory.
pub fn encode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    if (gcd(a, m) > 1) {
        return AffineCipherError.NotCoprime;
    }
    var result: std.ArrayList(u8) = try .initCapacity(allocator, phrase.len);
    defer result.deinit(allocator);
    var lettersInGroup:usize = 0;
    for(phrase)|c|{
        if (c >= 'a' and c <= 'z'){
            if (lettersInGroup == 5) {
                 try result.append(allocator, ' ');
                 lettersInGroup = 0;
            }
            const i:u32 = c - 'a';
            const coeff:u32 = (a * i + b) % m;
            const encrypted:u8 = @intCast('a' + coeff);
            try result.append(allocator, encrypted);
            lettersInGroup += 1;
        }
        else if (c >= 'A' and c <= 'Z'){
            if (lettersInGroup == 5) {
                 try result.append(allocator, ' ');   
                lettersInGroup = 0;
            }
            const i:u32 = c - 'A';                
            const coeff:u32 = (a * i + b) % m;
            const encrypted:u8 = @intCast('a' + coeff);
            try result.append(allocator, encrypted);
            lettersInGroup += 1;
        } else if (c >= '0' and c <= '9'){
            if (lettersInGroup == 5) {
                 try result.append(allocator, ' ');   
            }
            try result.append(allocator, c);
            lettersInGroup += 1;
        }
    } 
    return result.toOwnedSlice(allocator);
}

/// Decodes `phrase` using the affine cipher. Caller owns the returned memory.
pub fn decode(allocator: mem.Allocator, phrase: []const u8, a: u8, b: u8) (mem.Allocator.Error || AffineCipherError)![]u8 {
    if (gcd(a, m) > 1) {
        return AffineCipherError.NotCoprime;
    }
    var result: std.ArrayList(u8) = try .initCapacity(allocator, phrase.len);
    defer result.deinit(allocator);

    const mmia_1:i32 = mmi(a);
    for(phrase)|c|{
      if (c >= 'a' and c <= 'z'){
            const lettter_position:i32 = c - 'a';
            const coeff:i32 = mmia_1 * (lettter_position - b) + m;
            const decoded_position:u8 = @intCast(@mod(coeff , m));
            try result.append(allocator, decoded_position  + 'a');
        } else if (c >= '0' or c <= '9'){
            try result.append(allocator, c);
        }        
    }  
    return result.toOwnedSlice(allocator);
}

fn mmi(a:u8 ) i32 {
    for(1..m)|x|{
        if ((a * x) % m == 1) {
            return @intCast(x);
        } 
    }
    return 0;
}

fn gcd(a: u8, b: u8) u8 {
    if (a == 0){
        return b;
    }
    if (b == 0){
        return a;
    }
    if (a > b){
        return gcd(b, a % b);
    } else {
        return gcd(b, a);
    }
}

