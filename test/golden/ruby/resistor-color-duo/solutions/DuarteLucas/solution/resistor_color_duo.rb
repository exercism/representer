=begin
Write your code for the 'Resistor Color Duo' exercise in this file. Make the tests in
`resistor_color_duo_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/resistor-color-duo` directory.
=end
class ResistorColorDuo
  def self.value(color_names)
    colors = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white']
    color_code = []
    if color_names.length() == 3
      color_names.pop()
    end
  
    for color_name in color_names do
      color_code.push(colors.index("#{color_name}"))
    end
    return color_code.join.to_i
  end
end
  