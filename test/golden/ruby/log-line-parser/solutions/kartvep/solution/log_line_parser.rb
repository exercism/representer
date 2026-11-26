class LogLineParser
  def initialize(line)
    @line = line
  end

  def message
    return @line[@line.index(': ')+2, @line.size].strip
  end

  def log_level
    return @line[1, @line.index(':')-2].downcase
  end

  def reformat
    return "#{self.message} (#{log_level})"
  end
end
