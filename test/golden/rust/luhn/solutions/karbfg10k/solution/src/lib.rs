pub fn is_valid(s: &str) -> bool{
    let valid = String::from("1234567890 ");
    if s.chars().any(|c| !valid.contains(c) ){
        return false;
    }

    let mut n: Vec<u32> = s
        .chars()
        .filter(|c| c.is_ascii_digit())
        .map(|c| c.to_digit(10).unwrap() )
        .collect();

    if n.len() < 2 {
        return false;
    }

    for (i, val) in n.iter_mut().rev().enumerate(){
        if i % 2 != 0{
            *val *= 2;
            if *val > 9 {
                *val -= 9;
            }
        }
    }
    
    let sum: u32 = n
        .iter()
        .sum();

    sum % 10 == 0
}