class CollatzConjecture
  def self.steps(n)
    raise ArgumentError unless n.positive?
    counter = 0
    while n != 1
      n = n.even? ?  n / 2 : 3 * n + 1
      counter += 1
    end

    counter
  end
end
