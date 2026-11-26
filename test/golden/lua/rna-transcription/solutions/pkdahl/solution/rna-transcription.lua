return function(dna)
  local trans = { G = 'C', C = 'G', T = 'A', A = 'U' }
  return string.gsub(dna, "%a", trans)
end
