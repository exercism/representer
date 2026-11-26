pub fn raindrops(num: u32) -> String {
    let mut rain = String::new();
    if num % 3 == 0 {
        rain.push_str("Pling");
    }
    if num % 5 == 0 {
        rain.push_str("Plang");
    }
    if num % 7 == 0 {
        rain.push_str("Plong");
    }
    if rain.is_empty() {
        rain = num.to_string();
    }
    rain
}