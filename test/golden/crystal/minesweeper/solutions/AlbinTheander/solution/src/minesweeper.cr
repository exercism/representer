class Minesweeper
  def initialize(field : Array(String))
    @field = field
  end

  def contains_mine(x, y)
    if y < 0 || y >= @field.size
      return false
    end
    row = @field[y]
    if x < 0 || x >= row.size
      return false
    end
    row[x] == '*'
  end

  def count_mines(x, y)
    count = 0
    dy = -1
    while dy <= 1
      dx = -1
      while dx <= 1
        if contains_mine(x + dx, y + dy)
          count += 1
        end
        dx += 1
      end
      dy += 1
    end
    count
  end

  def annotate
    result = [] of String
    @field.each_with_index() do | row, y |
      new_row = ""
      row.each_char_with_index do | ch, x |
        close_mines = count_mines(x, y)
        if ch == '*'
          new_row += ch
        elsif close_mines == 0
          new_row += ' '
        else
          new_row += close_mines.to_s
        end
      end
      result << new_row
    end
    result
  end
end
