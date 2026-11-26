# frozen_string_literal: true

# Resistor Color Duo
class ResistorColorDuo
  COLORS = %w[black brown red orange yellow green blue violet grey white].freeze

  def self.value(names)
    names.first(2).map { |name| COLORS.index(name) }.join.to_i
  end
end
