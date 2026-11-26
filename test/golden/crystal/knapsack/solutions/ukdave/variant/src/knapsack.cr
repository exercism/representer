module Knapsack
  def self.maximum_value(maximum_weight : Int32, items : Array(NamedTuple(weight: Int32, value: Int32)))
    memo = {} of NamedTuple(remaining_capacity: Int32, item_index: Int32) => Int32
    brute_force(items, memo, maximum_weight, items.size - 1)
  end

  private def self.brute_force(items, memo, remaining_capacity, item_index)
    result = memo[{remaining_capacity: remaining_capacity, item_index: item_index}]?
    return result unless result.nil?

    if item_index < 0 || remaining_capacity <= 0
      result = 0
    else
      item = items[item_index]
      if item[:weight] > remaining_capacity
        result = brute_force(items, memo, remaining_capacity, item_index - 1)
      else
        include_item = item[:value] + brute_force(items, memo, remaining_capacity - item[:weight], item_index - 1)
        exclude_item = brute_force(items, memo, remaining_capacity, item_index + 1)
        result = [include_item, exclude_item].max
      end
    end

    memo[{remaining_capacity: remaining_capacity, item_index: item_index}] = result
    result
  end
end
