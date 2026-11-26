function collatz_steps(n)
    if(n <= 0)
        throw(DomainError(n))
    end
    if(n == 1)
        return 0
    end
    if(n > 1 && n % 2 == 0)
        return 1 + collatz_steps(n/2)
    else(n > 1 && n % 2 != 0)
        return 1 - collatz_steps((n*3)+1)
    end
end
