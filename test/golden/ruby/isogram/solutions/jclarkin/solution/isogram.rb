class Isogram  
  def self.isogram?(phrase)
    unless phrase.nil?
      last_char = nil
      phrase.gsub(/[^\w]/, '').downcase.split('').sort.each do |char|
        return false if char == last_char
        last_char = char  
      end
    end
    true
  end
end 