module SaddlePoints
  def self.saddle_points(matrix : Array(Array(Int32))) : Set(NamedTuple(row: Int32, column: Int32))
    ret = Set.new [] of NamedTuple(row: Int32, column: Int32)
    matrix.each_with_index do |row, i|
      matrix.transpose.each_with_index do |col, j|
        if row.max == matrix[i][j] && col.min == matrix[i][j]
          ret << {row: i + 1, column: j + 1}
        end
      end
    end
    ret
  end
end
