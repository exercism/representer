local DNA = {}
function DNA:new(s)
    local dna = {
        s = s,
    }
    if string.match(s, "[^ATGC]") then
        return error("Invalid Sequence")
    end
    setmetatable(dna,self)
    self.__index = self

    dna.nucleotideCounts = dna:calculateNucleotideCounts()

    return dna

end

function DNA:count(nuc)
    local letter = ""
    local cnt = 0
    if not string.match(nuc,"[GTAC]") then
        return error("Invalid Nucleotide")
    end
    for i = 1,#self.s do
        letter = string.sub(self.s,i,i)
        if letter == nuc then
            cnt = cnt + 1
        end
    end
    return cnt
end

function DNA:calculateNucleotideCounts()
    return {
        A = self:count('A'),
        T = self:count('T'),
        G = self:count('G'),
        C = self:count('C')
    }
end

return DNA
