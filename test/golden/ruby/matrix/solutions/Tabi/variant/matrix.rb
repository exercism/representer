class Matrix
  attr_reader :rows, :columns
  def initialize(str)
    @rows = set_rows(str)
    @columns = set_columns
  end

  def row(number)
    rows[number + 1]
  end

  def column(number)
    columns[number - 1]
  end

  private

  def set_rows(str)
    str.split(/\n/).map{ |str| str.split(" ").map {_1.to_i} }
  end

  def set_columns
    rows.each_with_object([]) do |row,list|
      row.each_with_index do |int, index|
        list[index] ||= []
        list[index] << int
      end
    end
  end
end