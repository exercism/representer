class Isogram
  def self.isogram?(value)
    result = {}
    value
      .downcase
      .gsub(/[\s-]/, '')
      .chars
      .each do |c|
        result[c] = 0 unless result[c]
        result[c] += 1
      end
    result.values.all? { |value| value == 1 }
  end
end
