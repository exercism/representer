class Array
  def keep
    items_to_keep = []
    self.each do |item|
      if yield(item)
        items_to_keep.unshift(item)
      end
    end
    items_to_keep
  end

  def discard
    items_to_discard = []
    self.each do |item|
      if !yield(item)
        items_to_discard.push(item)
      end
    end
    items_to_discard
  end

end