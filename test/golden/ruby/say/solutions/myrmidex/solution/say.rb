class Say

  SMALLS = {
    0 => 'zero',
    1 => 'one',
    2 => 'two',
    3 => 'three',
    4 => 'four',
    5 => 'five',
    6 => 'six',
    7 => 'seven',
    8 => 'eight',
    9 => 'nine',
    10 => 'ten',
    11 => 'eleven',
    12 => 'twelve',
    13 => 'thirteen',
    14 => 'fourteen',
    15 => 'fifteen',
    16 => 'sixteen',
    17 => 'seventeen',
    18 => 'eighteen',
    19 => 'nineteen',
  }

  TENS = {
    20 => 'twenty',
    30 => 'thirty',
    40 => 'forty',
    50 => 'fifty',
    60 => 'sixty',
    70 => 'seventy',
    80 => 'eighty',
    90 => 'ninety',
  }

  OTHER_MAGNITUDES = { # 1,000,000
    100 => { name: 'hundred', length: 1 },
    1000 => { name: 'thousand', length: 3 },
    1000000 => { name: 'million', length: 3 },
    1000000000 => { name: 'billion', length: 3 },
  }

  def initialize(number)
    raise ArgumentError if number < 0 || number > 999_999_999_999

    @number = number
  end

  def in_english
    texts = OTHER_MAGNITUDES
      .map { |(magnitude, info)| magnitude_to_text(magnitude, info) }
      .compact
      .reverse

    tens_text = tens_to_text
    texts << tens_text unless tens_text.nil?

    texts.join(" ")
  end

  private

  def magnitude_to_text(magnitude, magnitude_info)
    return if @number < magnitude

    nag_number = get_last_n_letters_from_string((@number / magnitude).to_i.to_s, magnitude_info[:length]).to_i

    return if nag_number == 0

    "#{Say.new(nag_number).in_english} #{magnitude_info[:name]}"
  end

  def tens_to_text
    return SMALLS[@number] if @number < 20

    number = @number % 100

    return nil if number == 0

    tens_index = TENS
      .select { |t| t <= number }
      .keys
      .reverse
      .first

    tens_text = TENS[tens_index]
    remainder = number - tens_index

    return tens_text if remainder == 0

    "#{tens_text}-#{SMALLS[remainder]}"
  end

  def get_last_n_letters_from_string(string, n)
    n = string.length if n > string.length

    string[-n..-1]
  end
end