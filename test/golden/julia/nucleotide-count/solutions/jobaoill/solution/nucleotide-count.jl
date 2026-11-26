"""
    count_nucleotides(strand)

The count of each nucleotide within `strand` as a dictionary.

Invalid strands raise a `DomainError`.

"""
function count_nucleotides(strand)
    nucleotides="ACGT"
    A_counts=0
    C_counts=0
    G_counts=0
    T_counts=0
    for item in strand
		@show !occursin(item,nucleotides)
        if !occursin(item, nucleotides)
            throw(DomainError(strand, "Strand contains invalid characters "))
        elseif item=='A'
            A_counts+=1
        elseif item=='C'
            C_counts+=1
        elseif item=='G'
            G_counts+=1
        elseif item=='T'
            T_counts+=1            
        end
    end
    return Dict([('A',A_counts),('C',C_counts),('G',G_counts),('T',T_counts)])
end
