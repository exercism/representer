public function score(float x, float y) returns int {
    float dist = x*x + y*y;

    if dist <= 1.0 {
        return 10;
    } else if dist <= 25.0 {
        return 5;
    } else if dist <= 100.0 {
        return 1;
    } else {
        return 0;
    }
}
