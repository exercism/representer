module FlattenArray
  extend self

  def flatten(array)
    array.flatten.compact
  end
end