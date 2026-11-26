@namespace "matrix"

function read(filename, matrix_var,    i, j) {
    for (i = 1; getline < filename; i++)
        for (j = 1; j <= NF; j++)
            matrix_var[i][j] = $j
}
function row(matrix_var, row_num,    res, n, i, j) {
    n = length(matrix_var[row_num])
    res = matrix_var[row_num][1]
    for (j = 2; j <= n; j++)
        res = res " " matrix_var[row_num][j]
    return res
}
function column(matrix_var, column_num,    res, n, i, j) {
    n = length(matrix_var)
    res = matrix_var[1][column_num]
    for (i = 2; i <= n; i++)
        res = res " " matrix_var[i][column_num]
    return res
}

