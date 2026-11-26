public function anagrams(string word, string[] candidates) returns string[] {
    string subject = word.toLowerAscii();
    map<int> sh = histo(subject);

    string[] result = [];
    foreach string c in candidates {
        string lw = c.toLowerAscii();
        if lw != subject && histoMatch(sh, lw) {
            result.push(c);
        }
    }
    return result;
}

function histo(string s) returns map<int> {
    map<int> h = {};
    foreach string r in s {
        if h.hasKey(r) {
            h[r] = h.get(r) + 1;
        } else {
            h[r] = 1;
        }
    }
    return h;
}

function histoMatch(map<int> h, string word) returns boolean {
    map<int> wh = {};
    foreach string r in word {
        if !h.hasKey(r) {
            return false;
        }
        if wh.hasKey(r) {
            wh[r] = wh.get(r) + 1;
        } else {
            wh[r] = 1;
        }
    }
    return wh == h;
}
