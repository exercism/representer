const innerRadius = 1.0;
const innerScore = 10;
const middleRadius = 5.0;
const middleScore = 5;
const outerRadius = 10.0;
const outerScore = 1;

public function score(float x, float y) returns int {
    float d = (x * x + y * y).sqrt();
    if d <= innerRadius {
        return innerScore;
    }
    if d <= middleRadius {
        return middleScore;
    }
    if d <= outerRadius {
        return outerScore;
    }
    return 0;
}
