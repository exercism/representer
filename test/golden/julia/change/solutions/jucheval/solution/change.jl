function change(coins, target)
    if target < 0
        throw(DomainError("negative change"))
    elseif target == 0
        return []
    end
    iterative = Dict()
    push!(iterative, 0 => [])

    for subtarget in 1:target
        min_coins = nothing
        for coin in coins
            if coin <= subtarget
                iterative[subtarget - coin] === nothing && continue
                if min_coins === nothing || length(iterative[subtarget - coin]) + 1 < length(min_coins)
                    min_coins = [coin; iterative[subtarget - coin]]
                end
            end
        end
        iterative[subtarget] = min_coins
    end

    output = iterative[target]
    if output === nothing
        throw(DomainError("impossible change"))
    end

    return output
end