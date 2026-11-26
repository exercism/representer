function rationalize(successes, trials)
    return successes.//trials
end

function probabilities(successes, trials)
    return successes./trials
end

function checkmean(successes, trials)
    mean_rational = sum(rationalize(successes, trials))/length(successes)
    mean_real = sum(probabilities(successes, trials))/length(successes)
    return float(mean_rational) == mean_real && mean_rational
end

function checkprob(successes, trials)
    total_rational = prod(rationalize(successes, trials))
    total_real = prod(probabilities(successes, trials))
    return float(total_rational) == total_real || total_rational
end
