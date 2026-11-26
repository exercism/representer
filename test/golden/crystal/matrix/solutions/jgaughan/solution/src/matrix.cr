class Matrix
  @matrix : Array(Array(Int32))

  def initialize(str : String)
    @matrix = str.lines.map do |line|
      line.split.map do |value|
        value.to_i
      end
    end
  end

  def row(row : Int32) : Array(Int32)
    @matrix[row - 1]
  end

  def column(column : Int32) : Array(Int32)
    @matrix.map &.[column - 1]
  end
end
