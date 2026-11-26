use std::collections::HashMap;

use std::thread;
use std::sync::mpsc::{Sender,Receiver,channel};

pub fn frequency<'a>(input: &'a[&str], worker_count: usize) -> HashMap<char, usize> {
    // trivial case
    if input.is_empty(){
        return HashMap::new();
    }
    
    // frequency maps channel
    let (tx_freq, rx_freq) = channel();
    {
        // sender and receiver, one of each per worker
        let mut txs = vec!();
        let mut rxs = vec!();
        for _k in 0..worker_count {
            let (tx, rx):(Sender<String>,Receiver<String>) = channel();
            txs.push(tx);
            rxs.push(rx);
        }
        // listen to each channel for inputs
        for rx in rxs {
            
            let tx_freq2 = Sender::clone(&tx_freq);
           
            thread::spawn(move ||{
                let mut hm = HashMap::new();
                while let Ok(i) = rx.recv() {
                    // add to map
                    for chr in i.chars().filter(|c| c.is_alphabetic()) {
                        *hm.entry(chr).or_insert(0)+=1;
                    }
                }
                // send result
                tx_freq2.send(hm).unwrap();
            });
        }
        // drop initial frequency map sender
        drop(tx_freq);
        let mut ix=0;
        // send input split per channel
        for i in input {
            let s = String::from(*i);
            txs[ix].send(s).unwrap();
            ix+=1;
            if ix==worker_count {
                ix=0;
            }
        }
    }
    let mut hm = HashMap::new();
    // reduce step, all worker_count maps into one
    for phm in rx_freq {
        for (k,v) in phm {
            if let Some(c) = k.to_lowercase().next() {
                *hm.entry(c).or_insert(0)+=v;
            }
        }
    }
    hm
}