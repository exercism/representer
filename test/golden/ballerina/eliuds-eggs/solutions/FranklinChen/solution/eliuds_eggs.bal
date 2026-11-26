public function eggCount(int displayValue) returns int {
    int result = 0;
    int remaining = displayValue;

    while (remaining != 0) {
        result += remaining & 1;
        remaining >>= 1;
    }

    return result;
}
