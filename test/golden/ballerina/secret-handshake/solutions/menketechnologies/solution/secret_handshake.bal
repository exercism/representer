function commands(int number) returns string[] {
    string[] result = [];
    if (number & 1) > 0 {
        result.push("wink");
    }
    if (number & 2) > 0 {
        result.push("double blink");
    }
    if (number & 4) > 0 {
        result.push("close your eyes");
    }
    if (number & 8) > 0 {
        result.push("jump");
    }
    if (number & 16) > 0 {
        result = result.reverse();
    }
    return result;
}
