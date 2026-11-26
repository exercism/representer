=begin
Write your code for the 'Hamming' exercise in this file. Make the tests in
`hamming_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/hamming` directory.
=end

class Hamming
  def self.compute(str1, str2)
    raise ArgumentError if (str1.length != str2.length)
    dis = 0
    str1.split('').each_with_index{|c, index|
      if (c != str2[index])
        dis += 1
      end
    }

    return dis
  end
end