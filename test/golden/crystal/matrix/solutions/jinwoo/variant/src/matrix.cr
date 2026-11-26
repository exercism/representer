class Matrix
  @rows : Array(Array(Int32))

  def initialize(str : String)
    @rows = str.each_line.map(&.split.map(&.to_i).to_a).to_a
  end

  def row(n)
    @rows[n - 1]
  end

  def column(n)
    @rows.map(&.[n + 1])
  end
end
