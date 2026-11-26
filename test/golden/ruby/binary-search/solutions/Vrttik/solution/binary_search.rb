=begin
Write your code for the 'Binary Search' exercise in this file. Make the tests in
`binary_search_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/binary-search` directory.
=end
class BinarySearch

  def initialize(array_of_values)
    @array_of_values = array_of_values
  end

  def search_for(value_to_find)
    @array_of_values.index(value_to_find)
  end
end
