pub fn raindrops(n: u32) -> String {
    let mut raindrop_sounds = String::new();
    if n % 3 == 0 {
        raindrop_sounds.push_str("Pling");
    }
    if n % 5 == 0 {
        raindrop_sounds.push_str("Plang");
    }
    if n % 7 == 0 {
        raindrop_sounds.push_str("Plong");
    }
    if (n % 3 != 0) && (n % 5 != 0) && (n % 7 != 0) {
        raindrop_sounds = n.to_string();
    }
    raindrop_sounds
}
