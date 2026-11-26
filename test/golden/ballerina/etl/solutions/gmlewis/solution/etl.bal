public function transform(map<string[]> old) returns map<int> {
    map<int> result = {};
    foreach string key in old.keys() {
        foreach string r in old.get(key) {
            int|error v = int:fromString(key);
            if v is int {
                result[r.toLowerAscii()] = v;
            }
        }
    }
    return result;
}
