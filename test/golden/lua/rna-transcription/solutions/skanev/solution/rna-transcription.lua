local rna = {
  G = 'C',
  C = 'G',
  T = 'A',
  A = 'U',
}
return function(dna)
  return dna:gsub('.', rna)
end
