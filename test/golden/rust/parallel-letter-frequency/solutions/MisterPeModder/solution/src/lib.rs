use std::collections::HashMap;
use std::sync::Arc;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let lines: Vec<String> = input.iter().map(|line| line.to_lowercase()).collect();
    let data = Arc::new(lines);
    let mut workers = Vec::new();
    for i in 0..worker_count {
        let worker_data = data.clone();
        workers.push(thread::spawn(move || {
            let mut freq = HashMap::new();
            let mut j = i;
            while j < worker_data.len() {
                for c in worker_data[j].chars().filter(|c| c.is_alphabetic()) {
                    *freq.entry(c).or_insert(0) += 1;
                }
                j += worker_count;
            }
            freq
        }));
    }
    let mut freq: HashMap<char, usize> = HashMap::new();
    for worker in workers {
        for (k, v) in worker.join().unwrap() {
            *freq.entry(k).or_insert(0) += v;
        }
    }
    freq
}
