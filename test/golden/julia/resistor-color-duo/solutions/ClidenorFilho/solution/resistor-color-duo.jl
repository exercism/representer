function colorcode(colors)
    color_map = Dict(
        "black" => 0,
        "brown" => 1,
        "red" => 2,
        "orange" => 3,
        "yellow" => 4,
        "green" => 5,
        "blue" => 6,
        "violet" => 7,
        "grey" => 8,
        "white" => 9
    )

    # Pega apenas as duas primeiras cores
    first_two = colors[1:2]

    # Converte cada cor para o dígito correspondente
    digits = [color_map[c] for c in first_two]

    # Concatena os dígitos como string e converte para inteiro
    return parse(Int, string(digits[1], digits[2]))
end
