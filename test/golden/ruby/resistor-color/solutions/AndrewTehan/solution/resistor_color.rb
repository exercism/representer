class ResistorColor
  COLORS_HASH = {'black' => 0, 'brown' => 1, 'red' => 2, 'orange' => 3, 'yellow' => 4, 'green' => 5, 'blue' => 6, 'violet' => 7, 'grey' => 8, 'white' => 9}
  COLORS = COLORS_HASH.keys
  def self.color_code(color)
    COLORS_HASH[color]
  end
end