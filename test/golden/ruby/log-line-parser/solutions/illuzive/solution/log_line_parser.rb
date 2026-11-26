class LogLineParser
  attr_reader :log_level, :message

  def initialize(line)
    sections = line.split(':')

    @log_level = sections.first.gsub(/[\[\]\s]/, '').downcase # strip unwanted chars and downcase
    @message = sections.last.strip
  end

  def reformat
    "#{message} (#{log_level})"
  end
end
