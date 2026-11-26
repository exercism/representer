module ETL
  def self.transform(input : Hash(String, Array(String))) : Hash(String, Int32)
    hash = {} of String => Int32
    input.each do |key, value|
      value.each do |letter|
        lowercase = letter.downcase
        hash[lowercase] = key.to_i
      end
    end
    hash
  end
end
