ismine(r, c, mf) = (0 <r  < size(mf)[1]+1) && (0 < c < size(mf)[2]+1) && (mf[r, c] == 42) ? (return true) : (return false)
function countadjacentmines(row, col, minefield)
    count = 0
    visit = [row-1 col; row+1 col; row col+1; row col-1; row-1 col+1; row-1 col-1; row+1 col+1; row+1 col-1]
    for i =1:size(visit)[1]
        ismine(visit[i,1], visit[i,2], minefield) && (count+=1)
    end
    return count
end
function annotate(minefield)
    (length(minefield) == 0) && (return minefield)
    board = fill(0, length(minefield), length(minefield[1]))
    tmp = Array{String, 2}(undef, length(minefield), length(minefield[1]))
    p = 1
    for n in eachindex(minefield)
        y = minefield[n]
        for m in eachindex(y)
            board[n,m]=Int(y[m])
            p+=1                       
        end
    end
    for i = 1:size(board)[1] 
        for j = 1:size(board)[2]
            (board[i,j] == 42) ? (board[i,j] = 42) : (board[i,j] = countadjacentmines(i, j, board))
            (board[i,j] == 0) && (board[i,j] = 32)         
            (board[i,j] == 32) && (tmp[i,j] = string(Char(board[i,j])))           
            (board[i,j] == 42) && (tmp[i,j] = string(Char(board[i,j])))        
            (board[i,j] != 42) && (board[i,j] != 32) && (tmp[i,j] = string(board[i,j]))         
        end
    end
    empty!(minefield)
    for row in eachrow(tmp)
        push!(minefield,reduce(*, row))
    end
    return minefield 
end