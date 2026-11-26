pub const NucleotideError = error{Invalid};

pub const Counts = struct {
    a: u32,
    c: u32,
    g: u32,
    t: u32,
};

fn contains(comptime T: type, arr: []const T, want: T) bool {
    for (arr) |item| {
        if (item == want) {
            return true;
        }
    }

    return false;
}

pub fn countNucleotides(s: []const u8) NucleotideError!Counts {
    const valid: [4]u8 = .{'A', 'C', 'G', 'T'};
    var counts = Counts{
        .a = 0,
        .c = 0,
        .g = 0,
        .t = 0,
    };

    for (s) |nucleotide| {
        if (!contains(u8, &valid, nucleotide)) {
            return error.Invalid;
        }
        
        switch (nucleotide) {
            'A' => { counts.a += 1; },
            'C' => { counts.c += 1; },
            'G' => { counts.g += 1; },
            'T' => { counts.t += 1; },
            else => unreachable,
        }
    }

    return counts;
}
