class LogLineParser
  def initialize(line)
    pattern = /\[(?<log_level>.*)\]: (?<message>.*)/
    match = line.match(pattern)
    @log_level = match[:log_level].sub('[', '').downcase
    @message = match[:message].strip
  end

  def message
    @message
  end

  def log_level
    @log_level
  end

  def reformat
    "#{message} (#{log_level})"
  end
end
