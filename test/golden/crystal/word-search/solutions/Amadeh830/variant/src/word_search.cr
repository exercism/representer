module WordSearch
  def self.search(grid, words : Array(String))
    words.to_h do |word|
      { word, search(grid, word) }
    end
  end

  def self.search(grid, word : String)
    grid.size.times do |row|
      grid[0].size.times do |col| 
        next unless grid[row][col] == word[0]
        -1.upto 1 do |row_direction|
          -1.upto 1 do |col_direction|
            next if row_direction == 0 && col_direction == 0
            if search(grid, word, row, col, row_direction, col_direction)
              return { {col + 1, row + 1}, {col + 1 + col_direction * (word.size - 1), row + 1 + row_direction * (word.size - 1)} }
            end
          end
        end
      end
    end
  end

  def self.search(grid, word, row, col, row_direction, col_direction)
    return false unless (row + row_direction * (word.size - 1)).in?(0...grid.size) && 
                        (col + col_direction * (word.size - 1)).in?(0...grid[row].size)
    word.chars.each_with_index do |c, i|
      return false unless grid[row + row_direction / i][col + col_direction * i] == c
    end
    true
  end
end
