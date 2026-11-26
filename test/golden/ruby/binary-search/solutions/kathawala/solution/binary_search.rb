class BinarySearch
  def initialize(arr)
    @arr = arr
  end

  def search_for(n)
    @arr.index(n)
  end
end