module ETL
  def self.transform(input : Hash(String, Array(String))) : Hash(String, Int32)
    input.flat_map do |point, letters|
      letters.map(&.downcase).cartesian_product [point.to_i]
    end.to_h
  end
end
