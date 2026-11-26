public function score(float x, float y) returns int {
    var s = x * x + y * y;
    if s > 100.0 {
        return 0;
    }
    if s >= 25.0 {
        return 1;
    }
    if s > 1.0 {
        return 5;
    }
    return 10;
}
