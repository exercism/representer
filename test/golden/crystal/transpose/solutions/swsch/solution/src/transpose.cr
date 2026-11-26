module Transpose
  alias Cell = Tuple(Int32, Int32)

  def self.transpose(input : String) : String
    width = 0
    heights = Hash(Int32, Int32).new { |hash, key| hash[key] = 0 }
    matrix = Hash(Cell, Char).new { |hash, key| hash[key] = ' ' }
    input.split('\n').each_with_index do |line, row|
      width = Math.max(width, line.size)
      line.chars.each_with_index do |char, col|
        heights[col] = row + 1
        matrix[{row, col}] = char
      end
    end
    (0...width).map do |col|
      (0...heights[col]).map { |row| matrix[{row, col}] }.join
    end.join("\n")
  end
end
