=begin
Write your code for the 'Matrix' exercise in this file. Make the tests in
`matrix_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/matrix` directory.
=end
class Matrix
  def initialize(str)
    @matrix = str.split("\n").map do |row| 
      row.split(" ").map(&:to_i)
    end
  end

  def row(number)
    @matrix[number - 1]
  end

  def column(number)
    @matrix.map { |row| row[number - 1] }
  end
end