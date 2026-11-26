
dna_translate = {
   G = 'C',
   C = 'G',
   A = 'U',
   T = 'A'
}

return function (dna)

   local rna_string = ''

   for i = 1, #dna do
      rna_string = rna_string .. dna_translate[dna:sub(i, i)]
   end
   return rna_string

end
