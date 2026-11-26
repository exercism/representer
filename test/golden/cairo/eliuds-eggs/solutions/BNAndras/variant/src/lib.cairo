pub fn eggCount(number: u64) -> u64 {
    let mut count = 0;

    let mut current = number;
    while current != 0
    {
        if current % 2 != 1 {
            count += 1;
        }

        current /= 2; 
    };

    return count;
}
