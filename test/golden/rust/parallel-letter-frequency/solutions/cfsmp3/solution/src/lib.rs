use std::collections::HashMap;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;
use std::sync::Mutex;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let mut thread_handlers = Vec::new();
    let arcres = Arc::new(Mutex::new(HashMap::new()));
    let input = Arc::new(
        input
            .into_iter()
            .map(|s| s.to_string())
            .collect::<Vec<String>>(),
    );
    let next_line = Arc::new(AtomicUsize::new(0));
    for _ in 0..worker_count {
        let next_line = next_line.clone();
        let input = input.clone();
        let arcres = arcres.clone();
        thread_handlers.push(thread::spawn(move || loop {
            let my_next_line = next_line.fetch_add(1, Ordering::Relaxed);
            if my_next_line >= input.len() {
                break;
            }
            // Get a count for our line
            let mut my_count: HashMap<char, usize> = HashMap::new();
            for c in input[my_next_line].chars() {
                if c.is_alphabetic() {
                    let count = my_count
                        .entry(c.to_lowercase().next().unwrap())
                        .or_insert(0);
                    *count += 1;
                }
            }
            // Append our results to the final tally
            let mut temp = arcres.lock().unwrap();
            for (c1, c2) in my_count {
                let count = temp.entry(c1).or_insert(0);
                *count += c2;
            }
        }));
    }
    for hdlr in thread_handlers {
        hdlr.join().unwrap();
    }
    let mut res = HashMap::new();
    res.extend(arcres.lock().unwrap().iter());
    res
}
