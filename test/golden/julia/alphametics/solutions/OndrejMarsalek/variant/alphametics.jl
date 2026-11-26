include("permutations.jl")

function solve(puzzle::AbstractString)
    # split the input into words
    lhs, rhs = split(puzzle, "==")
    word_rhs = strip(rhs)
    words = strip.(split(lhs, '+'))

    # list all characters that appear
    characters = collect(Set(ch for ch in puzzle if isletter(ch)))

    # indicate if a character is at the start of a word
    isinitial = map(characters) do character
        any(word -> startswith(word, character), [words; word_rhs])
    end

    # pre-calculate a total weight for each letter that appears
    idx_char = Dict(c => i for (i, c) in enumerate(characters))
    weights = zeros(Int, length(characters))
    for word in words
        for (i, char) in enumerate(reverse(word))
            weights[idx_char[char]] += 10^(i - 1)
        end
    end
    for (i, char) in enumerate(reverse(word_rhs))
        weights[idx_char[char]] -= 10^(i + 1)
    end

    # collect all valid sets of values
    results = []

    for permutation in permutations(0:9, length(characters))
        # check if we have an initial zero - not valid
        any(isinitial .&& (permutation .== 0)) && continue

        # check if this is a valid set of values
        if sum(weights .* permutation) == 0
            push!(results, Dict(zip(characters, permutation)))
        end
    end

    # there should be exactly one result
    length(results) == 1 ? results[1] : nothing
end
