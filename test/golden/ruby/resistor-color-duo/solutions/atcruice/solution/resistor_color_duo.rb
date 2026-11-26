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

  def self.value(bands)
    bands
      .first(2)
      .map { |band| COLORS.index(band) }
      .join
      .to_i
  end
end
