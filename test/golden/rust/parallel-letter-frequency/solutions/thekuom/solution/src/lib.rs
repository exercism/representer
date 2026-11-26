use std::collections::HashMap;
use std::sync::{Mutex, Arc};
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    let mutex = Arc::new(Mutex::new(HashMap::new()));
    let input_arc: Arc<Vec<_>> = Arc::new(input.iter().map(|line| line.to_string()).collect());

    let mut handles = Vec::new();

    for worker in 0..worker_count {
        let c_mutex = mutex.clone();
        let c_input = input_arc.clone();

        let handle = thread::spawn(move || {
            let mut thread_map = HashMap::new();

            c_input
                .iter()
                .skip(worker)
                .step_by(worker_count)
                .for_each(|line| {
                    line.chars().filter(|c| c.is_alphabetic()).for_each(|chr| {
                        if let Some(c) = chr.to_lowercase().next() {
                            (*thread_map.entry(c).or_insert(0)) += 1;
                        }
                    })
                });

            let mut map = c_mutex.lock().unwrap();
            thread_map
                .iter()
                .for_each(|(&key, val)| {
                    (*map.entry(key).or_insert(0)) += val;
                });
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    let lock = Arc::try_unwrap(mutex).expect("Lock still has multiple owners");
    lock.into_inner().expect("Mutex cannot be locked")
}
