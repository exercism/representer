module CollatzConjecture
  def self.steps(n : Int)
    n > 0 ? steps(0, n) : raise ArgumentError.new()
  end

  private def self.steps(steps : Int, n : Int)
    n == 1 ? steps : n.even? ? steps(steps+1, n // 2) : steps(steps+1, 3 * n + 1)
  end
end

