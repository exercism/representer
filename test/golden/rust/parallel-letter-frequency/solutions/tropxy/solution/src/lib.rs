use std::collections::HashMap;
use std::thread;

pub fn count(input: &[String]) -> HashMap<char, usize> {
    input.iter().fold(HashMap::new(), |mut map, word| {
        word.to_ascii_lowercase()
            .chars()
            .filter(|ch| ch.is_alphabetic())
            .for_each(|ch| {
                *map.entry(ch).or_insert(0) += 1;
            });
        map
    })
}

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let mut freq: HashMap<char, usize> = HashMap::new();
    if input.is_empty() {
        return freq;
    }
    let mut handlers = vec![];

    let number_of_sentences = input.len();
    // The interval gives us the even number of sentences per worker
    let interval = (number_of_sentences / worker_count).max(1);

    for chunk in input.chunks(interval) {
        let temp_data = chunk
            .iter()
            .map(|s| (*s).to_string())
            .collect::<Vec<String>>();
        let handler = thread::spawn(move || count(&temp_data));
        handlers.push(handler);
    }
    // Collect all entries to one hashmap
    for thread in handlers {
        for (k, v) in thread.join().unwrap() {
            *freq.entry(k).or_insert(0) += v;
        }
    }
    freq
}
