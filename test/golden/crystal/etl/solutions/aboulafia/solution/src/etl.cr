module ETL
  def self.transform(input : Hash(String, Array(String))) : Hash(String, Int32)
    r = Hash(String, Int32).new
    input.each do |score, letters|
      letters.each do |letter|
        r[letter.downcase] = score.to_i
      end
    end
    r
  end
end
