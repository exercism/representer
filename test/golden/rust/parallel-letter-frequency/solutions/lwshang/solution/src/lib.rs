use std::{collections::HashMap, thread};

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let mut output: HashMap<char, usize> = HashMap::new();
    let mut worker_results = vec![];
    // map
    for chunk in input.chunks(input.len() / worker_count + 1) {
        let data = chunk
            .iter()
            .map(|s| (*s).to_string())
            .collect::<Vec<String>>();
        worker_results.push(thread::spawn(move || -> HashMap<char, usize> {
            let mut result: HashMap<char, usize> = HashMap::new();
            data.iter().for_each(|line| {
                line.to_lowercase()
                    .chars()
                    .filter(|c| c.is_alphabetic())
                    .for_each(|c| *result.entry(c).or_insert(0) += 1)
            });
            result
        }))
    }
    // reduce
    for result in worker_results {
        for (c, n) in result.join().unwrap() {
            *output.entry(c).or_insert(0) += n;
        }
    }
    output
}
