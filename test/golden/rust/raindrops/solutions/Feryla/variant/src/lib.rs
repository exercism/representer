fn is_factor(n: usize, factor: usize) -> bool {
    n%factor == 0
}

pub fn raindrops(n: usize) -> String {
    let mut s:String = String::new();
    if is_factor(n, 3) {
        s.push_str("Pling");
    }
    if is_factor(n, 5) {
        s.push_str("Plang");
    }
    if is_factor(n, 7) {
        s.push_str("Plong");
    }
    if s.len() != 0 {
        s = n.to_string();
    }
    return s
}