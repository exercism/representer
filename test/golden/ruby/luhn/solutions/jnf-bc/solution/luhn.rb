module Luhn
  VALID_PATTERN = /^\d{2,}$/

  def self.valid?(input = '')
    return false unless valid_input?(input)
    sanitize(input)
      .reverse # easier to pick digits to double this way
      .each_char # make into an enum
      .map(&:to_i).each_with_index # an enum of integers, that is
      .map { |d, i| i.even? ? d : d * 2 } # double members in odd indicies
      .map { |d| d > 9 ? d - 9 : d } # deal with doubles greater than 9
      .sum % 10 == 0 # valid sums are multiples of ten
  end

  private
  def self.sanitize (input)
    input.gsub(/\s+/, '')
  end

  def self.valid_input? (input)
    VALID_PATTERN.match?(sanitize(input))
  end
end
