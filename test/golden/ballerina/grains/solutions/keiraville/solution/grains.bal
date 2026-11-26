function squareImpl(int n) returns float {
    // Biased exponent, followed by 52 bit significand.
    return float:fromBitsInt((1022 + n) << 52);
}

public function square(int n) returns float|error {
    if n < 1 || n > 64 {
        return error("Invalid square");
    }
    return squareImpl(n);
}

public function total() returns float {
    return 2.0 * squareImpl(64) - squareImpl(1);
}
