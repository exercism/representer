class Pangram

  def self.pangram?(phrase)

    alphabet = Hash.new(0)
    ('a'..'z').each do |e|
      alphabet[e.to_sym] = 0
    end

    phrase.downcase.each_char do |e|
      if alphabet.has_key?(e.to_sym)
        alphabet[e.to_sym] = 1
      end
    end

    sum = alphabet.each_value.to_a.reduce(:+)

    # puts "sum: #{sum}"
    # puts "alphabet: #{alphabet}"

    sum == 26 ? true : false
  end

end

module BookKeeping
  VERSION = 5
end

if __FILE__ != $PROGRAM_NAME
  puts Pangram.pangram?('abc')
  puts Pangram.pangram?('the quick brown fox jumps over the lazy dog')
end