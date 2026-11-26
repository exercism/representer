module FlattenArray
  def self.flatten(input : Array) : Array
    input.flatten.compact
  end
end
