class Pangram
  def self.pangram?(text)
    ('a'..'z').all?{|x| text.downcase.include?(x)}
  end
end