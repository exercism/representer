public function reverse(string str) returns string|error {
    return string:fromCodePointInts(str.toCodePointInts().reverse());
}
