class Matrix
  def initialize(s)
    @data = s.split("\n").map do |row|
      row.split(' ').map(&:to_i)
    end
  end

  def row(n)
    @data[n - 1]
  end

  def column(n)
    @data.map {|row| row[n-1] }
  end
end
