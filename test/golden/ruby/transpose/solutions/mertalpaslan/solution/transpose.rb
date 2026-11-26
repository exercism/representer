=begin
Write your code for the 'Transpose' exercise in this file. Make the tests in
`transpose_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/transpose` directory.
=end

class Transpose
  def self.transpose input
    arr = input.gsub(' ', '_').split("\n").map(&:chars)
    l = arr.map(&:length).max
    arr.map { |a| a + ([' '] * (l - a.length)) }
      .transpose
      .map { |a| a.join.rstrip.gsub('_', ' ')}
      .join("\n")
  end
end

