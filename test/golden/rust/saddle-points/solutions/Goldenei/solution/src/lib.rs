pub fn find_saddle_points(input: &[Vec<u64>]) -> Vec<(usize, usize)> {
    let mut min_row = vec![];
    let mut min_col = vec![];
    let mut ret = Vec::new();
    let tr = transpose(&input);
    for row in input{
        min_row.push(row.iter().max());
    }
    for col in &tr{
        min_col.push(col.iter().min());
    }
    for i in 0..min_row.len(){
        for j in 0..min_col.len(){
            if min_row[i] == *min_row.iter().min().unwrap(){
                if min_col[j] == *min_row.iter().min().unwrap(){
                    ret.push((i, j));
                }
            }
        }
    }
    ret
}

pub fn transpose(input: &[Vec<u64>]) -> Vec<Vec<u64>>{
    //let mut new = vec![vec![];input.len()];
    let n = input.len();
    let m = input[0].len();
    let mut new = vec![vec![0;n];m];
    for i in 0..n{
        for j in 0..m{
            new[j][i] = input[i][j];
        }
    }
    new
}
