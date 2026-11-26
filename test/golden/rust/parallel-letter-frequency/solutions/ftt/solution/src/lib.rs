use std::collections::HashMap;
use std::sync::mpsc::channel;
use std::thread;

pub fn frequency(input: &[&str], worker_count: usize) -> HashMap<char, usize> {
    if worker_count < 1 {
        panic!("Number of workers should be greater than or equal to 1.");
    }

    // Create additional worker threads if more than one worker is requested.
    let (workers, channels) = match worker_count {
        1 => (Vec::with_capacity(0), Vec::with_capacity(0)),
        _ => (0..worker_count - 1)
            .map(|_| {
                let (sender, receiver) = channel();
                let worker = thread::spawn(move || get_local_counts(receiver.iter()));
                (worker, sender)
            })
            .unzip(),
    };

    // Send copies of inputs to appropriate channels.
    for i in 0..input.len() {
        let worker_index = i % worker_count;
        if worker_index != worker_count - 1 {
            channels[worker_index].send(input[i].to_owned()).unwrap();
        }
    }

    // Consume channels to signal to the workers that all inputs are sent.
    for _ in channels {}

    // Count own share.
    let mut counts = if input.len() >= worker_count {
        get_local_counts(input[worker_count - 1..].iter().step_by(worker_count))
    } else {
        HashMap::with_capacity(50)
    };

    // Join and merge results.
    for worker in workers {
        if let Ok(cnts) = worker.join() {
            for (letter, count) in cnts {
                *(counts.entry(letter).or_insert(0)) += count;
            }
        }
    }

    counts
}

fn get_local_counts<I, S>(inputs: I) -> HashMap<char, usize>
where
    I: Iterator<Item = S>,
    S: AsRef<str>,
{
    let mut counts = HashMap::with_capacity(50);
    for input in inputs {
        for letter in input
            .as_ref()
            .chars()
            .filter(|c| c.is_alphabetic())
            .flat_map(char::to_lowercase)
        {
            *(counts.entry(letter).or_insert(0)) += 1;
        }
    }
    counts
}
