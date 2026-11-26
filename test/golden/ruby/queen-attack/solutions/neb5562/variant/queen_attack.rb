=begin
Write your code for the 'Queen Attack' exercise in this file. Make the tests in
`queen_attack_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/queen-attack` directory.
=end

class Queens
  @white
  @black
  def initialize white:[1,1], black:[1,1]
    @white = white
    @black = black    
    raise ArgumentError.new() if @white[0] < 0 || @white[0] > 7
    raise ArgumentError.new() if @white[1] < 0 && @white[1] > 7
    raise ArgumentError.new() if @black[0] < 0 || @black[0] > 7
    raise ArgumentError.new() if @black[1] < 0 || @black[1] > 7
  end
  def attack?
    return true if @white[0] == @black[0] || @white[1] == @black[1]
    return true if @white[0] == @white[1] && @black[0] == @black[1]
    return true if @white[0] - @white[1] == @black[0] - @black[1]
    return true if @white[1] - @white[0] == @black[1] - @black[0]
    return true if @white.sum == @black.sum
    return false
  end
end