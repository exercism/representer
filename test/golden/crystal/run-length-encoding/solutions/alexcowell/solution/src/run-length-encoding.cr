module RunLengthEncoding
  extend self

  def encode(input)
    runs_for_unencoded(input)
      .map(&.encode)
      .join
  end

  def decode(input)
    runs_for_encoded(input)
      .map(&.decode)
      .join
  end

  private def runs_for_unencoded(input) : Array(Run)
    input.chars
         .chunks(&.itself)
         .map { |char, occurrences| Run.new(char, occurrences.size) }
  end

  private def runs_for_encoded(input) : Array(Run)
    runs = [] of Run

    current_count = ""
    input.each_char do |c|
      if c.number?
        current_count += c
      else
        runs << Run.new(c, current_count.empty? ? 1 : current_count.to_i)
        current_count = ""
      end
    end

    runs
  end

  struct Run
    def initialize(@character : Char, @count : Int32)
    end

    def encode
      "#{@count > 1 ? @count : nil}#{@character}"
    end

    def decode
      @character.to_s * @count
    end
  end
end