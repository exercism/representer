class ResistorColorDuo
  COLORS = %w[
    black
    brown
    red
    orange
    yellow
    green
    blue
    violet
    grey
    white
  ].freeze

  def self.value(colors)
    colors.first(2).map do |color| 
      COLORS.index(color)
    end.join.to_i
  end
end
