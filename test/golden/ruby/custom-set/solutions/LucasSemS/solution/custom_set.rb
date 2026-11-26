class CustomSet
  def initialize(elements = [])
    @elements = elements.uniq
  end

  # Verifica se está vazio
  def empty?
    @elements.empty?
  end

  # Verifica se o elemento pertence ao conjunto
  def member?(element)
    @elements.include?(element)
  end

  # Adiciona um elemento ao conjunto
  def add(element)
    @elements << element unless member?(element)
    self
  end

  # Retorna os elementos
  def elements
    @elements.dup
  end

  # União de dois conjuntos
  def union(other_set)
    CustomSet.new(@elements + other_set.elements)
  end

  # Interseção de dois conjuntos
  def intersection(other_set)
    CustomSet.new(@elements.select { |e| other_set.member?(e) })
  end

  # Diferença de dois conjuntos
  def difference(other_set)
    CustomSet.new(@elements.reject { |e| other_set.member?(e) })
  end

  # Subconjunto
  def subset?(other_set)
    @elements.all? { |e| other_set.member?(e) }
  end

  # Disjunto
  def disjoint?(other_set)
    @elements.none? { |e| other_set.member?(e) }
  end

  # Igualdade entre conjuntos (útil para testes)
  def ==(other)
    @elements.sort == other.elements.sort
  end
end
