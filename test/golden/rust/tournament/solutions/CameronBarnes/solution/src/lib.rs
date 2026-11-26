use std::{cmp::Ordering, collections::HashMap, fmt::Display};

pub fn tally(match_results: &str) -> String {
    let mut map: HashMap<String, [i32; 3]> = HashMap::new();
    match_results.lines().for_each(|line| {
        let vals = line.split(';').map(String::from).collect::<Vec<_>>();
        let (score_a, score_b) = match vals[2].as_str() {
            "win" => ([1, 0, 0], [0, 0, 1]),
            "loss" => ([0, 0, 1], [1, 0, 0]),
            "draw" => ([0, 1, 0], [0, 1, 0]),
            val => panic!("Invalid match result: {val}"),
        };
        map.entry(vals[0].clone())
            .and_modify(|score| {
                score[0] += score_a[0];
                score[1] += score_a[1];
                score[2] += score_a[2];
            })
            .or_insert(score_a);
        map.entry(vals[1].clone())
            .and_modify(|score| {
                score[0] += score_b[0];
                score[1] += score_b[1];
                score[2] += score_b[2];
            })
            .or_insert(score_b);
    });

    let mut results = map.iter().collect::<Vec<_>>();
    results.sort_by(|(name_a, score_a), (name_b, score_b)| {
        let points_a = score_a[0] * 3 + score_a[1];
        let points_b = score_b[0] * 3 + score_b[1];
        // This is switched around because we want highest first
        let cmp = points_b.cmp(&points_a);
        if cmp == Ordering::Equal {
            name_a.cmp(name_b)
        } else {
            cmp
        }
    });

    let mut out = format_line("Team", ["MP", "W", "D", "L", "P"]);
    for (name, score) in results {
        let mp = score.iter().sum();
        let points = score[0] * 3 + score[1];
        out.push('\n');
        out.push_str(&format_line(
            name,
            [mp, score[0], score[1], score[2], points],
        ));
    }
    out
}

fn format_line<T: Display, V: Display>(t: T, vals: [V; 5]) -> String {
    format!(
        "{t:<30} | {:>2} | {:>2} | {:>2} | {:>2} | {:>2}",
        vals[0], vals[1], vals[2], vals[3], vals[4]
    )
}
