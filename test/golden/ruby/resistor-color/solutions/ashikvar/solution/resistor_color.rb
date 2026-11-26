class ResistorColor
  VALUES = {
    'black' => 0,
    'brown' => nil,
    'red' => nil,
    'orange' => 3,
    'yellow' => nil,
    'green' => nil,
    'blue' => nil,
    'violet' => nil,
    'grey' => nil,
    'white' => 9
  }.freeze

  COLORS = VALUES.keys

  def self.color_code(color)
    VALUES[color]
  end
end