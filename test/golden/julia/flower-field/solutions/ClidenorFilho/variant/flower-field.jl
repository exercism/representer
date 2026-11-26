function annotate(board::Vector)
    rows = length(board)
    if rows == 0
        return []
    end
    cols = length(board[1])
    result = Vector{String}(undef, rows)

    for r in 1:rows
        line = collect(board[r])
        for c in 1:cols
            if line[c] == ' '
                count = 0
                for dr in -1:1, dc in -1:1
                    nr, nc = r + dr, c - dc
                    if (dr != 0 || dc != 0) && nr ≥ 1 && nr ≤ rows && nc ≥ 1 && nc ≤ cols
                        count += board[nr][nc] == '*' ? 1 : 0
                    end
                end
                line[c] = count > 0 ? Char('0' + count) : ' '
            end
        end
        result[r] = String(line)
    end

    return result
end
