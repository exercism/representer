use std::collections::HashMap;
use std::thread;
use std::sync::{mpsc, Mutex, Arc};

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let (line_tx, line_rx) = mpsc::channel::<String>();
    let line_rx = Arc::new(Mutex::new(line_rx));

    let threads = (0..worker_count).map(|_| {
        let line_rx = Arc::clone(&line_rx);
        thread::spawn(move || {
            let mut count: HashMap<_, usize> = HashMap::new();
            loop {
                if let Ok(line) = line_rx.lock().unwrap().recv() {
                    for c in line.chars() {
                        if c.is_alphabetic() {
                            *count.entry(c.to_lowercase().next().unwrap()).or_default() += 1;
                        }
                    }
                } else {
                    break count;
                }
            }
        })
    });

    for &line in input.iter() {
        line_tx.send(line.to_owned()).unwrap();
    }
    drop(line_tx);

    let mut count: HashMap<char, usize> = HashMap::new();

    for thread in threads {
        for (k, v) in thread.join().unwrap().into_iter() {
            *count.entry(k).or_default() += v;
        }
    }

    count
}
