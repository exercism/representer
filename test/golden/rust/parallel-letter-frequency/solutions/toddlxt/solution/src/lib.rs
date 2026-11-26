use std::thread;
use std::sync::mpsc;
use std::collections::HashMap;
use std::sync::{Arc, Mutex};

pub fn frequency(v: &[&str], n: usize) -> HashMap<char, usize> {
    let len = v.len();
    let input = Arc::new(v.iter().map(|s| s.to_lowercase()).collect::<Vec<String>>());
    let (tx, rx) = mpsc::channel();
    let quotient: usize = len / n;
    let res = Arc::new(Mutex::new(HashMap::new()));
    for i in 0..n {
        let (res, tx, input) = (res.clone(), tx.clone(), input.clone());
        thread::spawn(move || {
            let start = quotient * i;
            let end = if i < n - 1 {
                quotient * (i + 1)
            } else {
                len
            };
            let mut res = res.lock().unwrap();
            for j in start..end {
                for c in input.get(j).unwrap().chars().filter(|c| c
                    .is_alphabetic()) {
                    *res.entry(c).or_insert(0) += 1;
                }
            }
            tx.send(()).unwrap();
        });
        rx.recv().unwrap();
    }
    let ref t = *res.lock().unwrap();
    let mut s: HashMap<char, usize> = HashMap::new();
    for (ch, num) in t {
        s.insert(*ch, *num);
    }
    s
}