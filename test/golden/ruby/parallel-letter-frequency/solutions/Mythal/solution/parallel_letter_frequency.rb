class ParallelLetterFrequency
  def self.count(texts)
    char_count = Hash.new(0)
    return char_count if texts.empty?

    threads = texts.map do |text|
      Thread.new do
        format_text = text.downcase.gsub(/[^\p{L}a-z]/, '')
        format_text.each_char { |char| char_count[char] += 1 }
      end
    end
    threads.each(&:join)

    char_count
  end
end