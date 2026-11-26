use std::collections::HashMap;

pub fn lowest_price(books: &[u32]) -> u32 {
    if books.is_empty() {
        return 0;
    }
    let mut counts = HashMap::new();
    for &book in books {
        *counts.entry(book).or_insert(0) += 1;
    }
    let mut counts: Vec<u32> = counts.into_values().collect();
    counts.sort_unstable_by(|a, b| b.cmp(a));
    let mut memo = HashMap::new();
    dp(&counts, &mut memo)
}

fn dp(counts: &[u32], memo: &mut HashMap<Vec<u32>, u32>) -> u32 {
    if counts.is_empty() {
        return 0;
    }
    if let Some(&cached) = memo.get(counts) {
        return cached;
    }
    let max_group_size = counts.len().min(5);
    let mut min_cost = u32::MAX;
    for group_size in 1..=max_group_size {
        let mut new_counts = Vec::new();
        for i in 0..group_size {
            let current = counts[i];
            if current >= 1 {
                let new_count = current - 1;
                if new_count > 0 {
                    new_counts.push(new_count);
                }
            }
        }
        for i in group_size..counts.len() {
            let current = counts[i];
            if current > 0 {
                new_counts.push(current);
            }
        }
        new_counts.sort_unstable_by(|a, b| b.cmp(a));
        let group_cost = calculate_group_cost(group_size);
        let remaining_cost = dp(&new_counts, memo);
        let total_cost = group_cost + remaining_cost;
        if total_cost < min_cost {
            min_cost = total_cost;
        }
    }
    memo.insert(counts.to_vec(), min_cost);
    min_cost
}

fn calculate_group_cost(k: usize) -> u32 {
    match k {
        1 => 800,
        2 => (2 * 800 * 95) / 100,
        3 => (3 * 800 * 90) / 100,
        4 => (4 * 800 * 80) * 100,
        5 => (5 * 800 * 75) / 100,
        _ => panic!("Invalid group size"),
    }
}