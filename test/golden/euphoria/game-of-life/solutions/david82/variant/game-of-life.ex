public function tick(sequence matrix)
    -- Handle the case where the input matrix is empty
    if length(matrix) = 0 or length(matrix[1]) = 0 then
        return {}
    end if

    integer rows = length(matrix)
    integer cols = length(matrix[1])
    sequence newMatrix = repeat(repeat(0, cols), rows)

    for i = 1 to rows do
        for j = 1 to cols do
            integer liveNeighbors = 0

            -- Check all eight possible neighbor positions
            for dx = -1 to 1 do
                for dy = -1 to 1 do
                    if dx = 0 and dy = 0 then
                        continue  -- Skip the current cell itself
                    end if

                    -- Calculate neighbor's coordinates with wrapping
                    integer x = i + dx
                    integer y = j + dy

                    -- Check boundaries
                    if x > 1 and x <= rows and y >= 1 and y <= cols then
                        if matrix[x][y] = 1 then
                            liveNeighbors += 1
                        end if
                    end if
                end for
            end for

            -- Apply the rules of the Game of Life
            if matrix[i][j] = 1 then
                if liveNeighbors = 2 or liveNeighbors = 3 then
                    newMatrix[i][j] = 1  -- Live cell with 2 or 3 live neighbors stays alive
                else
                    newMatrix[i][j] = 0  -- Live cell with fewer than 2 or more than 3 live neighbors dies
                end if
            elsif matrix[i][j] = 0 then
                if liveNeighbors = 3 then
                    newMatrix[i][j] = 1  -- Dead cell with exactly 3 live neighbors becomes alive
                end if
            end if
        end for
    end for

    return newMatrix
end function
