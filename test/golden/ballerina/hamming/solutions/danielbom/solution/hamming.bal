public function distance(string strand1, string strand2) returns int|error {
    int index = 0;
    int count = 0;
    int n1 = strand1.length();
    int n2 = strand2.length();
    if n1 != n2 {
        return error("Unequal strand lengths");
    }
    while index < n1 {
        if strand1[index] != strand2[index] {
            count += 1;
        }
        index += 1;
    }
    return count;
}
