function rationalize(successes, trials)
    return [successes[i] // trials[i] for i in eachindex(successes)]
end

function probabilities(successes, trials)
    return [successes[i] / trials[i] for i in eachindex(successes)]
end

function checkmean(successes, trials)
    rats = rationalize(successes, trials)
    floats = probabilities(successes, trials)
    
    mean_rat = sum(rats) // length(rats)
    mean_float = sum(floats) / length(floats)
    
    return float(mean_rat) == mean_float ? true : mean_rat
end

function checkprob(successes, trials)
    rats = rationalize(successes, trials)
    floats = probabilities(successes, trials)
    
    prod_rat = prod(rats)
    prod_float = prod(floats)
    
    return float(prod_rat) == prod_float ? true : prod_rat
end
