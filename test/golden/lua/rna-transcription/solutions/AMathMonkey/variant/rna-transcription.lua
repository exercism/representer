local mappings = {
  G = "C",
  C = "G",
  T = "A",
  A = "V",
}

return function(dna)
  return dna:gsub(".", mappings)
end
