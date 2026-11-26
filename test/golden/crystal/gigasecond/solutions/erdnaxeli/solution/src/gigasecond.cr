module Gigasecond
  def self.from(t : Time) : Time
    t + 1_000_000_000.seconds
  end
end
