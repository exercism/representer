class OcrNumbers

  VALID_NUMBERS = [
    [" _ ",
     "| |",
     "|_|",
     "   "],
    ["   ",
     "  |",
     "  |",
     "   "],
    [" _ ",
     " _|",
     "|_ ",
     "   "],
    [" _ ",
     " _|",
     " _|",
     "   "],
    ["   ",
     "|_|",
     "  |",
     "   "],
    [" _ ",
     "|_ ",
     " _|",
     "   "],
    [" _ ",
     "|_ ",
     "|_|",
     "   "],
    [" _ ",
     "  |",
     "  |",
     "   "],
    [" _ ",
     "|_|",
     "|_|",
     "   "],
    [" _ ",
     "|_|",
     " _|",
     "   "]
    ].freeze

  def self.convert(inp)
    inp_arr = inp.split("\n")
    raise ArgumentError unless input_valid?(inp_arr)
    inp_arr.each_slice(4).map do |line|
      all_digits = digits_from_line(line)
      all_digits.map{ |d| recognize_digit(d) }.join
    end.join(',')
  end

  class << self

    private

    def input_valid?(inp)
      valid_rows(inp) && valid_cols(inp)
    end

    def digits_from_line(line)
      line.map{ |l| l.scan(/.{1,3}/) }.transpose
    end

    def recognize_digit(inp)
      num = VALID_NUMBERS.find_index(inp)
      return num.to_s unless num.nil?
      "?"
    end

    def valid_rows(inp)
      inp.size % 4 == 0 && inp.size > 0
    end

    def valid_cols(inp)
      inp.all? { |l| l.size % 3 == 0 && l.size > 0 }
    end
  end
end