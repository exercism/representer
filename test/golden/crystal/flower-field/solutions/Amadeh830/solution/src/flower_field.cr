class FlowerField
  @field : Array(Array(Char))

  def initialize(field)
    @field = field.map &.chars
  end

  def annotate
    @field.each_with_index do |row, row_index|
      row.each_with_index do |sign, column_index|
        next if sign == '*'
        flower_count = 0
        -1.upto(1) do |i|
          -1.upto(1) do |j|
            next if i == 0 && j == 0
            next unless (row_index + i).in?(0...@field.size) && (column_index + j).in?(0...row.size)
            flower_count += 1 if @field[row_index + i][column_index + j] == '*'
          end
        end
        row[column_index] = flower_count.to_s[0] unless flower_count.zero?
      end
    end
    @field.map &.join
  end
end
