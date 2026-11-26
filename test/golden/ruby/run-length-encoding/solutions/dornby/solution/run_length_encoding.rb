class RunLengthEncoding

  def self.encode(raw_input)
    raw_input.gsub(/(.)\1+/) { |s| "#{s.length}#{s[0]}" }
  end

  def self.decode(raw_input)
    raw_input.gsub(/\d+./) {|s|  s[-1] * s.to_i}
  end

end
