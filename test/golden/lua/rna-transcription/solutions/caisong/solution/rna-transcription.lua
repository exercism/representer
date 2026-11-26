local transform = {G = 'C', C='G', T = 'A', A = 'U'}

return function(str)
    return string.gsub(str, '%a', function(ch) 
        return transform[ch] end)
end