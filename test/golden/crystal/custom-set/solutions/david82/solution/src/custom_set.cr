class CustomSet(T)
  def initialize(@elements : Array(T) = [] of T)
    @elements = @elements.uniq
  end

  def empty? : Bool
    @elements.empty?
  end

  def contains?(element : T) : Bool
    @elements.includes?(element)
  end

  def subset?(other : CustomSet(T)) : Bool
    @elements.all? { |el| other.contains?(el) }
  end

  def disjoint?(other : CustomSet(T)) : Bool
    @elements.none? { |el| other.contains?(el) }
  end

  def equal?(other : CustomSet(T)) : Bool
    self.size == other.size && self.subset?(other)
  end

  def add(element : T) : CustomSet(T)
    new_elements = @elements + [element]
    CustomSet.new(new_elements.uniq)
  end

  def intersection(other : CustomSet(T)) : CustomSet(T)
    intersection_elements = @elements.select { |el| other.contains?(el) }
    CustomSet.new(intersection_elements).sorted
  end

  def difference(other : CustomSet(T)) : CustomSet(T)
    difference_elements = @elements.reject { |el| other.contains?(el) }
    CustomSet.new(difference_elements).sorted
  end

  def union(other : CustomSet(T)) : CustomSet(T)
    union_elements = (@elements + other.elements).uniq
    CustomSet.new(union_elements).sorted
  end

  def size : Int32
    @elements.size
  end

  def ==(other : CustomSet(T)) : Bool
    self.sorted.elements == other.sorted.elements
  end

  protected def elements : Array(T)
    @elements
  end

  protected def sorted : CustomSet(T)
    CustomSet.new(@elements.sort)
  end
end
