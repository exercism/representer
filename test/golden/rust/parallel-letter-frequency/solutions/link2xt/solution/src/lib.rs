use std::collections::HashMap;
use std::thread;
use std::sync::{Arc, Mutex};

pub fn frequency(texts: &[&'static str], workers: usize) -> HashMap<char, usize> {
    let result = Arc::new(Mutex::new(HashMap::new()));

    let mut handles = Vec::new();
    for i in 0..workers {
        let lo = texts.len() / workers * i;
        let hi = if i == workers - 1 {
            texts.len()
        } else {
            texts.len() / workers * (i + 1)
        };

        for txt in &texts[lo..hi] {
            let result = result.clone();
            let txt = txt.clone();

            let handle = thread::spawn(move || {
                for c in txt.to_lowercase().chars().filter(|c| c.is_alphabetic()) {
                    let mut lock = result.lock().unwrap();
                    let mut e = lock.entry(c).or_insert(0);
                    *e += 1;
                }
            });
            handles.push(handle);
        }
    }

    for handle in handles {
        handle.join();
    }
    let result = result.lock().unwrap();
    result.clone()
}