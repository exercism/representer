module PalindromeProducts exposing (largest, smallest, PalindromeProduct)

-- Registro que guarda o valor do palíndromo e os fatores que o geraram
type alias PalindromeProduct =
    { value : Int
    , factors : List ( Int, Int )
    }


-- Verifica se um número é palíndromo
isPalindrome : Int -> Bool
isPalindrome n =
    let
        s = String.fromInt n
    in
    s == String.reverse s


-- Encontra o maior palíndromo possível no intervalo [min..max]
largest : Int -> Int -> Result String (Maybe PalindromeProduct)
largest min max =
    if min > max then
        -- Intervalo inválido
        Err "min must be <= max"

    else
        let
            -- Função recursiva que busca o maior palíndromo
            -- a, b: fatores atuais
            -- best: maior palíndromo encontrado até agora
            -- bestPairs: lista de pares que geram o maior palíndromo
            search a b best bestPairs =
                if a < min then
                    -- Todos os a foram testados
                    if best == 0 then
                        Nothing
                    else
                        Just { value = best, factors = bestPairs }

                else if b < min then
                    -- b terminou, decrementa a e reinicia b
                    search (a - 1) (a - 1) best bestPairs

                else
                    let
                        product = a * b
                    in
                    if product < best then
                        -- Nenhum produto maior possível com b menor
                        search (a - 1) (a - 1) best bestPairs

                    else if isPalindrome product then
                        if product > best then
                            -- Novo maior palíndromo, reinicia lista de pares
                            search a (b - 1) product [(a, b)]
                        else if product == best then
                            -- Mesmo valor do maior palíndromo, adiciona par
                            search a (b - 1) best ((a, b) :: bestPairs)
                        else
                            search a (b - 1) best bestPairs
                    else
                        -- Produto não é palíndromo, continua
                        search a (b - 1) best bestPairs
        in
        -- Executa a busca começando pelos maiores fatores
        case search max max 0 [] of
            Nothing -> Ok Nothing
            Just res ->
                        let
                            -- Normaliza e ordena os fatores antes de devolver
                            sortedFactors =
                                res.factors
                                    |> List.map normalizePair
                                    |> sortFactors
                        in
                        Ok (Just { res | factors = sortedFactors })


-- Encontra o menor palíndromo possível no intervalo [min..max]
smallest : Int -> Int -> Result String (Maybe PalindromeProduct)
smallest min max =
    if min > max then
        Err "min must be <= max"

    else
        let
            -- Função recursiva que busca o menor palíndromo
            -- a, b: fatores atuais
            -- best: menor palíndromo encontrado até agora
            -- bestPairs: lista de pares que geram o menor palíndromo
            search a b best bestPairs =
                if a > max then
                    -- Todos os a foram testados
                    if best == 0 then
                        Nothing
                    else
                        Just { value = best, factors = bestPairs }

                else if b > max then
                    -- b terminou, incrementa a e reinicia b
                    search (a + 1) (a + 1) best bestPairs

                else
                    let
                        product = a * b
                    in
                    if best /= 0 && product > best then
                        -- Nenhum produto menor possível com b maior
                        search (a + 1) (a + 1) best bestPairs

                    else if isPalindrome product then
                        if best == 0 || product < best then
                            -- Novo menor palíndromo, reinicia lista de pares
                            search a (b + 1) product [(a, b)]
                        else if product == best then
                            -- Mesmo valor do menor palíndromo, adiciona par
                            search a (b + 1) best ((a, b) :: bestPairs)
                        else
                            search a (b + 1) best bestPairs
                    else
                        -- Produto não é palíndromo, continua
                        search a (b + 1) best bestPairs
        in
        -- Executa a busca começando pelos menores fatores
        case search min min 0 [] of
            Nothing -> Ok Nothing
            Just res ->
                        let
                            -- Normaliza e ordena os fatores antes de devolver
                            sortedFactors =
                                res.factors
                                    |> List.map normalizePair
                                    |> sortFactors
                        in
                        Ok (Just { res | factors = sortedFactors })


-- Garante que o primeiro elemento do par seja menor ou igual ao segundo
normalizePair : (Int, Int) -> (Int, Int)
normalizePair (a, b) =
    if a <= b then
        (a, b)
    else
        (b, a)


-- Ordena a lista de pares de fatores
sortFactors : List (Int, Int) -> List (Int, Int)
sortFactors =
    List.sortWith (\(a1,b1) (a2,b2) -> compare (a1,b1) (a2,b2))
