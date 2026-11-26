module RunLengthEncoding
  extend self
  def encode(s : String)
    s.chars.chunks { |c| c }.map { |c, v| "#{v.size > 1 ? v.size : ""}#{c}" }.join
  end
  def decode(s : String)
    s.gsub(/\d+./) { |m| m[-1].to_s / m[0..-2].to_i }
  end
end