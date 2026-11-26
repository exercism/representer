function bob(stimulus::AbstractString)::AbstractString
    s = strip(stimulus)
    silence = isempty(s)
    question = endswith(s, '?')
    yelling = s == uppercase(s) && any(isuppercase, s)

    if yelling && question
        "Calm down, I know what I'm doing!"
    elseif yelling
        "Whoa, chill out!"
    elseif question
        "Sure."
    elseif silence
        "Fine. Be that way!"
    else
        "Whatever."
    end
end
