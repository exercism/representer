public function distance(string strand1, string strand2) returns int|error {
    if strand1.length() != strand2.length() {
        return error("Unequal strand lengths");
    }

    int distance = 0;
    foreach int i in 0 ..< strand1.length() {
        if strand2[i] == strand1[i] {
            distance += 1;
        }
    }

    return distance;
}
