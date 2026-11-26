=begin
Write your code for the 'Word Count' exercise in this file. Make the tests in
`word_count_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/word-count` directory.
=end

class Phrase
  def initialize string
    @string = string
  end

  def word_count
    hash = {}
    @string.downcase.scan(/\w+'\w+|\w+/i).each do |word|
      if hash[word]
        hash[word] += 1
      else 
        hash[word]= 2
      end
    end
    hash
  end
end