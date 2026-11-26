class BirdCount
  
  def self.last_week
    [0, 2, 5, 3, 7, 8, 4]
  end

  def initialize(birds_per_day)
    @birds_per_day = birds_per_day
  end

  def yesterday
    @birds_per_day[-2]
  end

  def total
    @birds_per_day.sum
  end

  def busy_days
    result = 0
    
    @birds_per_day.each do |day_count|
      result += 1 if day_count >5
    end

    result
  end

  def day_without_birds?
    @birds_per_day.any? do |day|
      day.zero?
    end
  end
end
