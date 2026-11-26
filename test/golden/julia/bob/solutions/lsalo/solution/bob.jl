function bob(stimulus)
    s = strip(stimulus)
    is_yell = s == uppercase(s) && any(isletter, s)
    silence = isempty(s)
    
    if endswith(s, "?")
        if is_yell
            response = "Calm down, I know what I'm doing!"
        else
            response = "Sure."
        end
    elseif is_yell
        response = "Whoa, chill out!"
    elseif silence
        response = "Fine. Be that way!"
    else
        response = "Whatever."
    end

    return response
end
