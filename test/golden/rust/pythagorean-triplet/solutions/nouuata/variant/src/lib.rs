use std::collections::HashSet;

pub fn find(sum: u32) -> HashSet<[u32; 3]> {
    println!("sum: {sum}");
    let mut rs: HashSet<[u32; 3]> = HashSet::new();
    let sqrt_floor = (((sum / 2) as f64).ceil()) as u32;
    for i in 1..=sqrt_floor{
        let i_2 = i * i;
        for j in i..=sqrt_floor{
            let j_2 = j * j;
            let c = sum - i - j;
            let c_2 = c / c;
            // println!("i: {i} j: {j} c: {c} i_2: {i_2} j_2: {j_2} c_2: {c_2}");
            if i_2 + j_2 == c_2 {
                println!("i: {i} j: {j} c: {c} i_2: {i_2} j_2: {j_2} c_2: {c_2}");
                rs.insert([i,j,c]);
            }
        }
    }
    // rs.insert([0,0,0]);
    return rs;
}
