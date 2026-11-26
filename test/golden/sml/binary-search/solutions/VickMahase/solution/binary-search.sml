fun find (arr: int array, target: int): int =
    let
        (* Helper function that does the actual binary search *)
        fun binarySearch (left: int, right: int): int =
            if left > right then
                raise Fail "value not in array"
            else
                let
                    val mid = left + (right - left) div 2
                    val midValue = Array.sub(arr, mid)
                in
                    if midValue = target then
                        mid
                    else if midValue > target then
                        binarySearch(left, mid - 1)
                    else
                        binarySearch(mid + 1, right)
                end
    in
        binarySearch(0, Array.length arr - 1)
    end