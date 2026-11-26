"Your optional docstring here"
function distance(a, b)

    if length(a) == length(b)
       hamming = 0
       for i = 1:length(a)
           if a[i] != b[i] 
                  hamming += 1
           end
       end
    else
         throw(ArgumentError("The two strings must have same length"))
    end
    return hamming
end
