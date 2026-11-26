function recite(pieces)
    n = 1
    output = ""
    pieces == [] && return output
    while n < length(pieces)
        output = output*"For want of a "*pieces[n]*" the "*pieces[n+1]*" was lost.\n"
        n += 1
    end
    output = output*"And all for the want of a "*pieces[1]*"."
    return output
end
