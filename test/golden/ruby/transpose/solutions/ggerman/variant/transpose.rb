=begin
Write your code for the 'Transpose' exercise in this file. Make the tests in
`transpose_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/transpose` directory.
=end

class Transpose
  class << self
    def transpose matrix
      rows = matrix.gsub(" ", "-").split("\n")
      largest = rows.map(&:length).max || 0
      
      rows = rows.each_with_index.map do |row, i| 
        future_max = rows[(i - 1)..].map(&:length).max || 0
        pad = [future_max, row.length].max
        row.chars.fill(" ", row.length, largest - row.length)
      end
      
      debug rows.tally
      rows.transpose
          .map(&:join).map(&:rstrip)
          .join("\n")
          .gsub("-", " ")
    end
  end
end
