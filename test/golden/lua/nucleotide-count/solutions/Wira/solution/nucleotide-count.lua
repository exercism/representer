local DNA = {}
DNA.__index = DNA

local function parse(dna)
  local tab = {A = 0, T = 0, C = 0, G = 0}
  for litera in dna:gmatch('.') do 
    if tab[litera] then 
      tab[litera] = tab[litera] + 1
    else
      error('Invalid Sequence')
    end
  end
  return tab
end

function DNA:new(dna)
  return setmetatable({nucleotideCounts = parse(dna)}, DNA)
end

function DNA:count(elem)
  return self.nucleotideCounts[elem] or error('Invalid Nucleotide')
end
return DNA
