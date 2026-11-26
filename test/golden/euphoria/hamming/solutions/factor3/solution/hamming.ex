include std/math.e

public function distance(sequence left, sequence right)
    if length(left) != length(right) then
        return "left and right strands must be of equal length"
    end if
    return sum(left != right)
end function