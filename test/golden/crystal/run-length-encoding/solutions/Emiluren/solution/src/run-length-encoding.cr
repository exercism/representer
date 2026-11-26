require "string_scanner"

module RunLengthEncoding
  class CharGroup
    property char, count

    def initialize(@char : Char, @count : Int32)
    end
  end

  def self.encode(str)
    String.build do |result|
      s = StringScanner.new(str)

      while seg = s.scan(/(.)\1*/)
        if seg.size == 1
          result << seg[0]
        else
          result << seg.size.to_s + seg[0]
        end
      end
    end
  end

  def self.decode(str)
    String.build do |result|
      s = StringScanner.new(str)

      while !s.eos?
        num = s.scan(/[0-9]*/).not_nil!.to_i { 1 }
        result << s.scan(/./).to_s * num
      end
    end
  end
end