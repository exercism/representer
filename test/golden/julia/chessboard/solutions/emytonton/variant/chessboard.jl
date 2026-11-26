# Retorna o range dos números das ranks (linhas)
function rank_range()
    return 1:9
end

# Retorna o range das letras das files (colunas)
function file_range()
    return 'A':'H'
end

# Retorna um vetor com todas as ranks (1 a 8)
function ranks()
    return collect(rank_range())
end

# Retorna um vetor com todas as files ('A' a 'H')
function files()
    return collect(file_range())
end

