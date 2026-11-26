module ETL
  def self.transform(input : Hash(String, Array(String))) : Hash(String, Int32)
    output = Hash(String, Int32).new
    input.each do |value, letters|
      letters.each { |letter| output[letter.downcase] = value.to_i }
    end
    output
  end
end
