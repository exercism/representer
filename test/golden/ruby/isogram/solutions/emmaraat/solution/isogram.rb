=begin
Write your code for the 'Isogram' exercise in this file. Make the tests in
`isogram_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/isogram` directory.

    letters = input.downcase.gsub('/[^a-z]/', '').gsub('/[-]/', '')

=end

class Isogram
  def self.isogram?(input)
    letters = input.downcase.scan(/[a-z]/)
    letter_unique = letters.uniq
    if letters.length == letter_unique.length
      true
    end

  end
end