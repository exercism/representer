use std::collections::HashMap;
use std::sync::mpsc;
use std::sync::mpsc::{Receiver, Sender};
use std::sync::*;
use std::thread;
use std::vec::*;
use std::iter::*;

pub fn frequency(input: &[&'static str], worker_count: usize) -> HashMap<char, usize> {
    if input.is_empty() {
        return HashMap::default()
    }
    let mut res: HashMap<char, usize> = HashMap::new();
    let chunk_size = (1.0 * input.len() as f32 / worker_count as f32).ceil() as usize;
    
    let chunks_s = input.clone().chunks(chunk_size);
    let mut threads = Vec::new();
    let chunk_vec = Vec::from_iter(chunks_s);

    let (results_send, results_recv) = mpsc::channel();
    for (w, c) in chunk_vec.iter().enumerate() {
        let (send, recv): (Sender<String>, Receiver<String>) = mpsc::channel();
        let chunk = Arc::new(Vec::from((*c).clone()));
        let send_handle = thread::spawn(move || {
            for t in chunk.iter() {
                let data = String::from(*t);
                send.send(data).unwrap();
            }
            drop(send);
        });
        send_handle.join().unwrap();

        let out_chan = results_send.clone();
        let t = thread::spawn(move || loop {
            let rec = recv.recv();
            match rec {
                Ok(r) => {
                    let mut out: HashMap<char, usize> = HashMap::new();
                    for c in r.to_lowercase().chars().filter(|c| c.is_alphabetic()) {
                        let prev = out.get(&c).unwrap_or(&0);
                        out.insert(c, prev + 1);
                    }
                    out_chan.send(out).unwrap();
                    thread::yield_now();
                }
                Err(err) => {
                    println!("closing worker {}", thread::current().name().unwrap_or("unnamed"));
                    break;
                }
            }
        });
        threads.push(t);
    }

    for t in threads {
        t.join().unwrap();
    }
    drop(results_send);

    for o in results_recv {
        println!("processing results {:?}", o);
        for k in o.keys() {
            let v = &o[k];
            let val = res.get(k).unwrap_or(&0) + v;
            res.insert(*k, val);
        }
    }

    res
}
