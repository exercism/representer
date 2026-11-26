pub fn get_diamond(c: char) -> Vec<String> {
    let mut half_result: Vec<String> = vec![];

    let range = 'A'..=c;
    let range_len = range.clone().count();

    for (i, c) in range.enumerate() {
        let mut half_row = String::with_capacity(range_len);
        for j in 0..range_len {
            if j == i {
                half_row.push(c);
            } else {
                half_row.push(' ');
            }
        }
        // mirror horizontally
        let mut row: String = half_row.chars().rev().collect::<String>();
        row.pop();
        row.push_str(&half_row);
        half_result.push(row);
    }
    println!("half_result: {:#?}", half_result);

    // mirror vertically
    let mut result: Vec<String> = half_result.clone();
    half_result.pop();
    half_result.reverse();
    for s in half_result {
        result.push(s);
    }

    result
}
