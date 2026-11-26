{
    split("M 1000 CM 900 D 500 CD 400 C 100 XC 90 L 50 XL 40 X 10 IX 9 V 5 IV 4 I 1", nums)
    
    for (i=1; i<length(nums); i+=2) {
        while ($1 / nums[i+1] > 1) {
            out = out nums[i]
            $1 -= nums[i+1]
        }
    }
    print out
}
