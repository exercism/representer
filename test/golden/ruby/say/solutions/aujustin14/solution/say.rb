class Say
  MAX = 999_999_999_999

  ONES = %w[
    _ one two three four five six seven eight nine ten
    eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen
  ].freeze
  TENS = %w[_ _ twenty thirty forty fifty sixty seventy eighty ninety].freeze
  SCALES = %w[_ thousand million billion].freeze

  attr_reader :in_english

  def initialize(number)
    raise ArgumentError unless number.between?(0, MAX)

    @in_english = number.zero? ? "zero" : pronounce(number)
  end

  private

  def pronounce(number)
    number.digits(1000)
          .each_with_index
          .filter_map { |chunk, i| pronounce_chunk(chunk, (SCALES[i] unless i.zero?)) unless chunk.zero? }
          .reverse
          .join(" ")
  end

  def pronounce_chunk(chunk, scale)
    [under_thousand(chunk), scale].compact.join(" ")
  end

  def under_thousand(n)
    hundreds, rest = n.divmod(100)
    words = []
    words << "#{ONES[hundreds]} hundred" if hundreds.positive?
    words << under_hundred(rest) if rest.positive?
    words.join(" ")
  end

  def under_hundred(n)
    return ONES[n] if n < 20

    tens, ones = n.divmod(10)
    ones.zero? ? TENS[tens] : "#{TENS[tens]}-#{ONES[ones]}"
  end
end