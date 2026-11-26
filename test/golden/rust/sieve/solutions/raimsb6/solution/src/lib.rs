pub fn primes_up_to(upper_bound: u64) -> Vec<u64> {
    let mut working_vec: Vec<Option<u64>> = Vec::new();
    for x in 2..=upper_bound {
        working_vec.push(Some(x));
    }

    let mut current_number = 0u64;
    loop {
        let working_num_opt = working_vec
            .iter()
            .find(|&x| x.is_some() && x.unwrap() > current_number)
            .map(|x| x.as_ref().unwrap());
        if let Some(&num) = working_num_opt {
            current_number = num;
            // start with first composite which is not the number itself
            let mut current_composite = current_number * 2;
            while current_composite <= upper_bound {
                let index = (current_composite - 2) as usize; // minus two because vector starts at 2
                working_vec[index].take(); // take out all multiples
                current_composite += current_number;
            }
        } else {
            // no more remaining numbers past current_number in working_num_opt
            break;
        }
    }

    working_vec.iter().filter_map(|&x| x).collect()
}
