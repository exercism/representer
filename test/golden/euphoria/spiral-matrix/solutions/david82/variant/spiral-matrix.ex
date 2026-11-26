public function spiralMatrix( integer size )
    if size = 0 then
        return {}
    end if
    
    sequence matrix = repeat(repeat(0, size), size)
    integer num = 1
    integer left = 1, right = size, top = 1, bottom = size

    while left < right and top <= bottom do
        -- Fill top row
        for i = left to right do
            matrix[top][i] = num
            num += 1
        end for
        top += 1

        -- Fill right column
        for i = top to bottom do
            matrix[i][right] = num
            num += 1
        end for
        right -= 1

        -- Fill bottom row
        if top <= bottom then
            for i = right to left by -1 do
                matrix[bottom][i] = num
                num += 1
            end for
            bottom -= 1
        end if

        -- Fill left column
        if left <= right then
            for i = bottom to top by -1 do
                matrix[i][left] = num
                num += 1
            end for
            left += 1
        end if
    end while

    return matrix
end function
