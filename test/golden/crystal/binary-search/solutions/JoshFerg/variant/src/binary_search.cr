class BinarySearch
  def initialize(@arr : Array(Int32)) ; end 

  def find(v : Int32) 
    raise ArgumentError.new if @arr.empty? && !v.in? @arr
    @arr.sort.index(v)
  end
end
