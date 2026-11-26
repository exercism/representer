=begin
Write your code for the 'Dominoes' exercise in this file. Make the tests in
`dominoes_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/dominoes` directory.
=end

class Dominoes
  class << self
    def chain?(stones)
      stones.empty? ? true : do_chain?(stones[0][1], stones.shift[0], stones)
    end

    private

    def do_chain?(left, right, stones)
      return true if stones.empty? && left == right

      stones.each_with_index.any? do |stone, i|
        [stone, stone.reverse].any? do |stone|
          left == stone[0] &&
            do_chain?(stone[1], right, stones.take(i) - stones.drop(i + 1))
        end
      end
    end
  end
end
