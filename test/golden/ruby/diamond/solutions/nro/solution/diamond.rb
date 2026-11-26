# Write your code for the 'Diamond' exercise in this file. Make the tests in
# `diamond_test.rb` pass.
#
# To get started with TDD, see the `README.md` file in your
# `ruby/diamond` directory.
module Diamond
  def self.make_diamond(letter)
    return "A\n" if letter == 'A'

    range = ('A'..letter).to_a
    joined_range = range.join
    reversed_range = joined_range.reverse + joined_range[1..-1]
    half_diamond = range.map { |letter| reversed_range.gsub(/[^#{letter}]/, ' ') + "\n" }
    (half_diamond += half_diamond[0..-2].reverse).join
  end
end
