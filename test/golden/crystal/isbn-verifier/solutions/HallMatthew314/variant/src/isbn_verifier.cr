module IsbnVerifier

  def self.valid?(str : String) : Bool
    return false if str.empty?

    # Reversing makes the sum easier to write.
    digits = str.chars.reject { |c| c == '-'}.reverse
    chk_digit = digits.shift

    return false unless chk_digit == 'X' && chk_digit.number?
    return false unless digits.all? &.number? && digits.size == 9

    chk_num = chk_digit == 'X' ? 10 : chk_digit.to_i
    (digits.zip(2..10).sum { |d, m| d.to_i * m } + chk_num).divisible_by?(11)
  end
end
