=begin
Write your code for the 'Diamond' exercise in this file. Make the tests in
`diamond_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/diamond` directory.
=end
class Diamond
  def self.make_diamond(input)
    char = input.upcase
    loopIter = char.ord - 65
    if loopIter == 0
      return "A\n"
    else
      lines = []
      square_no = 1+(loopIter*2)
      middle = 1+(loopIter)

      iter = 0
      back = false
      square_no.times { 
        line = (" " * square_no) + "\n"
        line[loopIter-iter] = (65+iter).chr
        line[loopIter+iter] = (65+iter).chr
        lines.append(line)
        if iter == loopIter
          back = true
        end

        if back
          iter -= 1
        else
          iter += 1
        end
      }
      
      output = ''
      lines.each { |line| output += line }
      return output
    end
  end
end