# Implement number base conversion

function all_your_base(digits, base_in, base_out)
    # tons of random exceptions to deal with for invalid inputs, in order to pass runtests
    if base_in < 2
        throw(DomainError(base_in,"$(base_in) is not a valid base (>=2)"))
    end
    if base_out < 2
        throw(DomainError(base_in,"$(base_in) is not a valid base (>=2)"))
    end
    if any(x -> x < 0, digits)
        throw(DomainError(digits,"some of $(digits) are negative"))
    end
    if any(x -> x >= base_in, digits)
        throw(DomainError(digits,"some of $(digits) are >= $(base_in)"))
    end
    if length(digits) == 0
        return [0]
    end

    # the actual work--build a basis vector consisting of all necessary powers
    # of base_in, then dot it with 'digits'
    basis = base_in .^ collect(0:(length(digits)-1))
    value = digits' * reverse(basis)

    if value == 0
        return [0]
    end

    # take advantage of generalized log function to compute max digits needed
    ndigits = (Int)(floor(log(base_out,value))) + 1

    retdigits = (Int)[]
    # basic division algorithm
    for i in 1:ndigits
        currentpower = base_out^(ndigits-i)
        currentdigit = (Int)(floor(value/currentpower))
        push!(retdigits,currentdigit)
        value = value - currentpower*currentdigit
    end
    return retdigits
end
