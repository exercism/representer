def count_mines(minefield, prow, pcol):
    directions = [[0,1],[1,0],[1,1],[0,-1],[-1,0],[-1,-1],[-1,1],[1,-1]]
    count = sum([minefield[prow + direction[0]][pcol + direction[1]] == "*" for direction in directions 
                    if (0 <= prow + direction[0] <= len(minefield) - 1 and 0 <= pcol + direction[1] <= len(minefield[0]) - 1)])
    if count == 0:
        return " "
    else:
        return str(count)
def annotate(minefield):  
    if minefield == []:
        return []
    else:
        nrows = len(minefield)
        ncols = len(minefield[0])
        for col in minefield:
            if len(col) != ncols:
                raise ValueError("The board is invalid with current input.")
        
        for i in range(nrows):
            temp_row = ""
            for j in range(ncols):
                if minefield[i][j].isspace():
                    temp_row += count_mines(minefield, i, j)
                elif minefield[i][j] == "*":
                    temp_row += "*"
                else:
                    raise ValueError("The board is invalid with current input.")
            minefield[i] = temp_row
            
        return minefield