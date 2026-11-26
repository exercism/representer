module main

fn row(str string, index int) []int {
    rows := str.split('\n')
    return rows[index - 1].split(' ').map(it.int())
}

fn column(str string, index int) []int {
    rows := str.split('\n').map(it.split(' ')).map(it.map(it.int()))
    mut cols := [][]int{}
    for i in 0..rows[0].len {
        mut col := []int{}
        for j in 0..rows.len{
            col << rows[j][i]
        }
        cols << col
    }
    return cols[index - 1]
}

