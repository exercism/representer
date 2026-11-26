use std::collections::HashMap;
use std::thread;
use std::sync::mpsc;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let line_count = input.len();
    // each worker gets at least one line
    let actual_worker_count = std::cmp::min(line_count, worker_count);
    let (tx, rx) = mpsc::channel();
    let mut workers = vec![];

    for w in 0 .. actual_worker_count {
        let mut lines: Vec<String> = vec![];
        let mut w_line_nr = w;
        while w_line_nr < line_count {
            lines.push(input[w_line_nr].chars().collect());
            w_line_nr += worker_count;
        }

        let w_tx = mpsc::Sender::clone(&tx);
        workers.push(thread::spawn(move || {
            let mut char_count: HashMap<char, usize> = HashMap::new();
            for line in lines {
                for c in line.to_lowercase().chars() {
                    if !c.is_alphabetic() { continue; }
                    if char_count.contains_key(&c) {
                        char_count.insert(c, char_count[&c] + 1);
                    }
                    else {
                        char_count.insert(c, 1);
                    }
                }
            }
            let mut msg = String::new();
            for (c, cnt) in &char_count {
                msg.push(*c);
                msg.push(',');
                msg.push_str(&cnt.to_string());
                msg.push(' ');                
            } 
            w_tx.send(msg).unwrap();
        }));
    }
    for w in workers {
        let _ = w.join();
    }

    // receive
    let mut result = HashMap::new();
    for _ in 0 .. actual_worker_count {
        let received = rx.recv().unwrap();
        for pair in received.split(" ") {
            let c_cnt: Vec<_> = pair.split(",").collect();
            if c_cnt[0].is_empty() || c_cnt[1].is_empty() {continue;} 

            let c = c_cnt[0].chars().next().unwrap();
            let cnt: usize = c_cnt[1].parse().unwrap();
            if result.contains_key(&c) {
                result.insert(c, result[&c] + cnt);
            }
            else {
                result.insert(c, cnt);
            }
        }
    }
    result
}
