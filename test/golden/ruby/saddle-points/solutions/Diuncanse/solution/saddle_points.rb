module Grid
  def self.saddle_points(rows)
    columns = rows.transpose
    rows.each_with_index.inject([]) do |points, (row, i)|
      row.each_with_index{|num, j| points << {"row" => i + 1, "column" => j + 1} if num === row.max and num === columns[j].min}
      points
    end
  end
end