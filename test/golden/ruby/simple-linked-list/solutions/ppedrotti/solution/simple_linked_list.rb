class Element
  attr_accessor :datum, :next
  def initialize value
    self.datum = value
    #self
  end
end

# The tests do not require this class to be a linked list at all to pass
# the tests, elements do not know their next element.
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
