local function maximum_value(maximum_weight, items)
  -- A função 'maximum_value' determina o valor máximo que pode ser obtido
  -- para uma mochila com capacidade máxima de peso.
  --
  -- Args:
  --   maximum_weight: O peso máximo que a mochila pode carregar.
  --   items: Uma tabela de itens, onde cada item tem um 'peso' e um 'valor'.
  --
  -- Retorna:
  --   O valor máximo total que a mochila pode conter.

  -- Cria uma tabela (matriz) 'dp' com tamanho 'maximum_weight + 1'.
  -- Cada índice 'w' representa um peso, e o valor em 'dp[w]'
  -- armazena o valor máximo que pode ser obtido para esse peso.
  -- A tabela é inicializada com zeros.
  local dp = {}
  for w = 0, maximum_weight do
    dp[w] = 0
  end

  -- Percorre cada item disponível.
  for i = 1, #items do
    local item = items[i]
    local item_weight = item.weight
    local item_value = item.value

    -- Percorre a tabela 'dp' de trás para frente.
    -- Isso é crucial para o problema 0/1, pois garante que cada item
    -- seja considerado apenas uma vez para cada peso. Se percorrêssemos
    -- de 1 a 'maximum_weight', um item poderia ser considerado várias vezes.
    for w = maximum_weight, item_weight, -1 do
      -- Calcula o valor de duas opções:
      -- 1. Não incluir o item atual: o valor é o que já está em 'dp[w]'.
      -- 2. Incluir o item atual: o valor é a soma do valor do item
      --    com o valor máximo que podíamos ter com o peso restante
      --    (ou seja, 'dp[w - item_weight]').
      
      -- Compara as duas opções e armazena o valor máximo.
      dp[w] = math.max(dp[w], dp[w - item_weight] + item_value)
    end
  end

  -- O valor máximo para o peso máximo da mochila é o último elemento da tabela.
  return dp[maximum_weight]
end

return { maximum_value = maximum_value }
