class Luhn
  def self.valid?(number)
    # remove spaces from input
    number.gsub!(" ", "")

    # numbers must have at least 2 digits
    return false if number.size < 2

    # numbers must not have non-numeric characters (other than spaces)
    return false unless /^\d+$/.match(number)
    
    sum = 0

    number.chars.each_with_index do |c,idx|
      val = c.to_i

      # double every other number, starting from the right
      if (idx + number.size) % 2 == 0
        val *= 2
        val -= 9 if val > 9
      end

      sum += val
    end

    sum % 10 == 0
  end
end