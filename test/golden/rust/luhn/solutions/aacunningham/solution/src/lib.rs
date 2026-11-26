pub fn is_valid(card_number: &str) -> bool {
    if card_number.chars()
                  .find(|&x: &char| !x.is_digit(10) & !x.is_whitespace())
                  .is_some() {
        return false;
    }

    let mut number_vec: Vec<u32> = card_number.chars().rev()
                                              .filter(|x| x.is_digit(10))
                                              .map(|x| x.to_digit(10).unwrap())
                                              .collect();

    if number_vec.len() < 2 {
        return false;
    }

    for chunk in number_vec.chunks_mut(2) {
        if chunk.len() == 2 {
            chunk[1] *= 2;
            if chunk[1] > 9 {
                chunk[1] -= 9;
            }
        }
    }
    
    let sum = number_vec.iter()
                        .fold(0, |acc, &x| acc + x);
    
    sum % 10 == 0
}