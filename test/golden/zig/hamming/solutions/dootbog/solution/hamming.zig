pub const DnaError = error{
    EmptyDnaStrands,
    UnequalDnaStrands,
};

pub fn compute(a: []const u8, b: []const u8) DnaError!usize {
    var ham: usize = 0;
    var i: u8 = 0;
    if (a.len == 0 or b.len == 0) return DnaError.EmptyDnaStrands;
    if (a.len != b.len) return DnaError.UnequalDnaStrands;
    while (i < a.len) : (i += 1) ham += if (a[i] != b[i]) 1 else 0;
    return ham;
}
