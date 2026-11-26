-- some improvements looked at mikowitz
local dnaToRNA = {A='U', C="G", G="C", T="A"}

function to_rna( dna )
    local newrna = {}
    for i = 1, #dna do        
        newrna[i] = dnaToRNA[string.sub(dna, i, i)]
    end 
    return table.concat(newrna, "")
end  

return to_rna;
