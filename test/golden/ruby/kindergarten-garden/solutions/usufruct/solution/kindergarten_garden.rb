# frozen_string_literal: true

class Garden
  DEFAULT_CLASS = %w[Alice Bob Charlie David
                     Eve Fred Ginny Harriet
                     Ileana Joseph Kincaid Larry].freeze
  PLANTS = {
    'G' => :grass,
    'C' => :clover,
    'R' => :radishes,
    'V' => :violets
  }.freeze

  def initialize(plants, students = DEFAULT_CLASS)
    boxes = plants.lines.map { |line| line.scan(/../) }.transpose
    students.sort.each_with_index do |student, index|
      method_name = student.downcase.to_sym
      define_singleton_method(method_name) do
        boxes[index]&.join&.chars&.map(&PLANTS)
      end
    end
  end
end