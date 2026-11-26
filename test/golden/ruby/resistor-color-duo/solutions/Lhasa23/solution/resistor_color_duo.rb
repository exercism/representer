=begin
Write your code for the 'Resistor Color Duo' exercise in this file. Make the tests in
`resistor_color_duo_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/resistor-color-duo` directory.
=end
module ResistorColorDuo
  COLOR_RESISTOR_DUO = %w{ black brown red orange yellow green blue violet grey white }

  class << self
    def value(colors)
      colors.map { |color| COLOR_RESISTOR_DUO.index(color) }.take(2).join.to_i
    end
  end
end
