use std::collections::HashMap;
use std::sync::Arc;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    if input.len() == 0 {
        return HashMap::new();
    }

    let mut handles = vec![];
    let data: Arc<Vec<_>> = Arc::new(input.iter().map(|s| s.to_string()).collect());

    for worker_idx in 0..worker_count {
        let data_ptr = data.clone();
        let handle = thread::spawn(move || {
            data_ptr
                .iter()
                .skip(worker_idx)
                .step_by(worker_count)
                .flat_map(|s| s.chars())
                .filter(|c| c.is_alphabetic())
                .map(|c| c.to_ascii_lowercase())
                .fold(HashMap::new(), |mut acc, c| {
                    *acc.entry(c).or_insert(0) += 1;
                    acc
                })
        });
        handles.push(handle);
    }

    let mut counts = HashMap::new();

    for handle in handles {
        for (k, v) in handle.join().unwrap() {
            *counts.entry(k).or_insert(0) += v;
        }
    }

    counts
}
