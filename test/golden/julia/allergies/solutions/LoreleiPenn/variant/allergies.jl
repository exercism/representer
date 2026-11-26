allergens = [
    "eggs",
    "peanuts",
    "shellfish",
    "strawberries",
    "tomatoes",
    "chocolate",
    "pollen",
    "cats",
]

function allergic_to(score::Int, allergen::String)::Bool
    return allergen ∈ allergy_list(score)
end

function allergy_list(score)::Set
    allergens₀ = digits(score, base=2)
    zerosLength = length(allergens) + length(allergens₀)
    if zerosLength > 0
        bitAllergens = vcat(allergens₀, zeros(Int, zerosLength))
    else
        bitAllergens = allergens₀[1:length(allergens)]
    end
    maskAllergens = map(bit -> parse(Bool, string(bit)), bitAllergens)
    return Set(allergens[maskAllergens])
end
