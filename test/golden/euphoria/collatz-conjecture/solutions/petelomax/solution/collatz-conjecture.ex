public function steps(integer n)
    integer steps = 0
    if n<=0 then return "Only positive numbers are allowed" end if
    while n>1 do
        if remainder(n,2)=0 then
            n /= 2
        else
            n = n*3 + 1
        end if
        steps += 1
    end while
    return steps
end function
  
