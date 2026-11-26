return function(dna)

local rna  = ""

dna:gsub(".", function(c)
    if c == "G" then rna = rna.."C"
    elseif c == "C" then rna = rna.."G"
    elseif c == "T" then rna = rna.."A"
    elseif c == "A" then rna = rna.."U"
    end
end)

return rna
end


