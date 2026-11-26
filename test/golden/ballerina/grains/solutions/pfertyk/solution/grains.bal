public function square(int n) returns float|error {
    if n < 1 || n > 64 {
        return error("Invalid square");
    }
    return <float>(n * n);
}

public function total() returns float {
    float result = 0.0;
    foreach int i in 1 ... 64 {
        result += checkpanic square(i);
    }
    return result;
}
