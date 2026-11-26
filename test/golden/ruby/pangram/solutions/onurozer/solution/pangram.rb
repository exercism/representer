class Pangram
  def self.pangram?(sentence)
    sentence.gsub!(/\W/,'')
    ('a'..'z').to_a.each{|c| return false unless sentence.downcase.chars.include? c}
  return true
  end
end