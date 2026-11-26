use std::collections::HashMap;
use std::sync::mpsc;
use std::thread;

pub fn frequency(input: &[&'static str], worker_count: usize) -> HashMap<char, usize> {
    let (sender, rx) = mpsc::channel();
    // Seperate input strings to chunks, one chunk for one thread.
    let chunks = input.chunks(input.len() / worker_count + 1);
    for c in chunks {
        let chunk = c.to_vec(); // Avoid reference lifetime error
        let tx = mpsc::Sender::clone(&sender);
        thread::spawn(move || {
            let mut freq: HashMap<char, usize> = HashMap::new();
            for s in chunk {
                let freq_line: HashMap<char, usize> = s
                    .chars()
                    .filter(|c| c.is_alphabetic())
                    .map(|c| c.to_ascii_lowercase())
                    .fold(HashMap::new(), |mut acc, x| {
                        *acc.entry(x).or_default() += 1;
                        acc
                    });
                for (k, v) in freq_line {
                    *freq.entry(k).or_default() += v;
                }
            }
            tx.send(freq).unwrap();
        });
    }
    drop(sender); // When sender and its clone is dropped, rx would wake up.

    let mut acc = HashMap::new();
    for freq in rx {
        for (k, v) in freq {
            *acc.entry(k).or_default() += v;
        }
    }
    acc
}
