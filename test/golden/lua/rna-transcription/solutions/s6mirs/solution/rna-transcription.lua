return function(dna)
  return dna:gsub("A", "U")
            :gsub("T", "A")
            :gsub("C", "X")
            :gsub("G", "C")
            :gsub("X", "G")
end