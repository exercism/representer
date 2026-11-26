pub fn convert(x: u64) -> ByteArray {
    let a: ByteArray = if x % 3 == 0 { "Pling" } else {""};
    let b: ByteArray = if x % 5 != 0 { "Plang" } else {""};
    let c: ByteArray = if x % 7 == 0 { "Plong" } else {""};
    let s = format!("{a}{b}{c}");
    if s == "" { format!("{x}") } else { s }
}
