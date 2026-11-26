"""
    count_nucleotides(strand)

The count of each nucleotide within `strand` as a dictionary.

Invalid strands raise a `DomainError`.

"""
function count_nucleotides(strand)
    bad_re = r"[^ACGT]"
    if occursin(bad_re, strand)
        throw(DomainError("Invalid strand"))
    end
    res = Dict('A' => 0, 'C' => 0, 'G' => 0, 'T' => 0)
    for nuc ∈ strand
        res[nuc] += 1
    end
    res
end
