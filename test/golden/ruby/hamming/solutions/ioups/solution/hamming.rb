=begin
Write your code for the 'Hamming' exercise in this file. Make the tests in
`hamming_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/hamming` directory.
=end
class Hamming

  def self.compute(str_1, str_2)
    #return 0 if str_1.empty? && str_2.empty?
    
    arr_1 = str_1.split("")
    arr_2 = str_2.split("")
    raise ArgumentError.new if arr_1.length != arr_2.length
    result = arr_1.select.each_with_index do |letter, index|
      arr_2[index] != letter
    end
    result.count
  end

end
