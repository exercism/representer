module Diamond
  
  def self.make_diamond(c)
    d = Drawer.new(c)
    d.draw_shape
  end
end

class Drawer
  ALL_LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  def initialize(char)
    @char = char
  end

  def draw_shape
    outer_space = ALL_LETTERS.index(@char)
    middle_space = -1
    draw("A", middle_space, outer_space)
  end

  def draw(c, middle_space, outer_space)
    return draw_line(c, middle_space, outer_space) if c == @char
    next_char = (c.ord + 1).chr
    draw_line(c, middle_space, outer_space) +
    draw(next_char, middle_space + 2, outer_space - 1) +
    draw_line(c, middle_space, outer_space)
  end

  def draw_line(c, middle_space, outer_space)
    return " " * outer_space + c + " " * outer_space + "\n" if middle_space <= 0
    " " * outer_space + c + " " * middle_space + c + " " * outer_space + "\n" 
  end
end

  