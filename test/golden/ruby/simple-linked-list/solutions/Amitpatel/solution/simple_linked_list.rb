=begin
Write your code for the 'Simple Linked List' exercise in this file. Make the tests in
`simple_linked_list_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/simple-linked-list` directory.
=end

class Element
  attr_accessor :datum, :next
  def initialize value
    self.datum = value
  end
end

class SimpleLinkedList
  def initialize array = []
    @elements = []
    array.each {|i| push Element.new(i)}
  end

  def to_a
    @elements.map(&:datum)
  end

  def push element
    @elements.unshift element
    self
  end

  def pop
    @elements.shift
  end

  def reverse!
    @elements.reverse!
    self
  end
end
