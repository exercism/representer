-- Função principal para anotar o jardim com a contagem de flores.
local function annotate(garden)
  -- Cria uma nova tabela para a cópia do jardim, garantindo que não há campos extras.
  local annotatedGarden = {}
  for _, line in ipairs(garden) do
    table.insert(annotatedGarden, line)
  end
  
  local height = #garden
  if height == 0 then
    -- Retorna o jardim vazio se não houver linhas.
    return annotatedGarden
  end
  local width = #garden[1]

  -- Loop principal que percorre cada célula do tabuleiro.
  for y = 1, height do
    for x = 1, width do
      -- Verifica se a célula atual é um espaço vazio.
      if annotatedGarden[y]:sub(x, x) == ' ' then
        -- Se for, inicia a contagem de flores adjacentes.
        local flowerCount = 0
        
        -- Verifica os 8 vizinhos (incluindo diagonais).
        for dy = -1, 1 do
          for dx = -1, 1 do
            -- Ignora a célula central (o próprio 'x,y').
            if not (dx == 0 and dy == 0) then
              local ny = y + dy
              local nx = x + dx
              
              -- Verifica se o vizinho está dentro dos limites do tabuleiro.
              if ny >= 1 and ny <= height and nx >= 1 and nx <= width then
                -- Se estiver dentro dos limites, verifica se o vizinho é uma flor '*'.
                if garden[ny]:sub(nx, nx) == '*' then
                  -- Incrementa o contador de flores se encontrar uma.
                  flowerCount = flowerCount + 1
                end
              end
            end
          end
        end
        
        -- Após contar todos os vizinhos, substitui o espaço vazio pelo número de flores.
        if flowerCount > 0 then
          local line = annotatedGarden[y]
          annotatedGarden[y] = line:sub(1, x-1) .. tostring(flowerCount) .. line:sub(x+1)
        end
      end
    end
  end
  
  -- Retorna o tabuleiro anotado.
  return annotatedGarden
end

-- Retorna a tabela do módulo, expondo a função 'annotate'.
return { annotate = annotate }
