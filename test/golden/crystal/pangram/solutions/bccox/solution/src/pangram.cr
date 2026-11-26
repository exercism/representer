module Pangram
  def self.pangram?(str)
    str = str.downcase
    ('a'..'z').all? { |c| str.includes? c }
  end
end