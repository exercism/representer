module Series
  def self.slices(series : String, slice_length : Number) : Array(String)
    raise ArgumentError.new if slice_length.zero? || series.size < slice_length
    arr = [] of String
    pos = 0
    while pos - slice_length <= series.size
      arr << series.chars[pos, slice_length].join
      pos += 1
    end
    arr
  end
end
