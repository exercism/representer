const ALPHABET: [char; 26] = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
    'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
];

pub fn get_diamond(c: char) -> Vec<String> {
    let index = ALPHABET.iter().position(|ch| *ch == c).unwrap();
    let len = index * 2 + 1;
    let mut output = (0..index + 1)
        .map(|i| {
            let mut line = vec![' '; len];
            line[index + i] = ALPHABET[i];
            line[index - i] = ALPHABET[i];
            line.iter().collect::<String>()
        })
        .collect::<Vec<String>>();

    let mut bottom = output[0..index].to_vec();
    bottom.reverse();

    output.extend(bottom);

    output
}
