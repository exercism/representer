function annotate(board)
    rows = length(board)
    cols = rows == 0 ? 0 : length(board[1])
    result = copy(board)

    for i in 1:rows
        row_chars = collect(result[i])
        for j in 1:cols
            if board[i][j] == '*'
                continue
            end

            count = 0
            for dx in -1:1, dy in -1:1
                x, y = i + dx, j + dy
                if dx == 0 && dy == 0
                    continue
                end
                if 1 ≤ x ≤ rows && 1 ≤ y ≤ cols
                    if board[x][y] == '*'
                        count += 1
                    end
                end
            end

            if count > 0
                row_chars[j] = Char('0' + count)
            end
        end
        result[i] = join(row_chars)
    end

    return result
end