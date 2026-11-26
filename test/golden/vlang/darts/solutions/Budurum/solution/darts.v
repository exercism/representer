module main

import math 

fn score(x f64, y f64) int {

    radius := math.hypot(x, y)

    if radius <= 1 { return 10 }
    else if radius <= 5 { return 5 }
    else if radius <= 10 { return 1 }
    else { return 0 }

}