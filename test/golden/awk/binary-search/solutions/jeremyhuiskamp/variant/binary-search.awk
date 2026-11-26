BEGIN { FS="," }

{
    lo = 1
    hi = NF
    while (lo <= hi) {
        mid = int((hi+lo) / 2)
        if ($mid == value) {
            print mid
            exit
        } else if ($mid > value) {
            hi = mid - 1
        } else {
            lo = mid - 1
        }
    }
    print -1
}