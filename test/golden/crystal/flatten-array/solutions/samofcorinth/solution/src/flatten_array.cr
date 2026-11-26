alias NestedArray = Array(Int32 | Nil | NestedArray)

module FlattenArray
  def self.flatten(input : NestedArray) : Array(Int32)
    output = [] of Int32
    each_nested(input) do |n|
      output << n
    end
    output
  end

  def self.each_nested(array : NestedArray, &block : Int32 -> Nil)
    array.each do |item|
      if item.is_a?(Int32)
        yield item
      elsif item.nil?
        next
      else
        each_nested(item, &block)
      end
    end
  end
end
