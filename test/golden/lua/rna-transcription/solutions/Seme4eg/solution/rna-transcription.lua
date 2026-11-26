return function(dna)
  return dna:gsub('[GCTA]', {G = 'C', C = 'G', T = 'A', A = 'U'})
end
