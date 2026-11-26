module Connect
  alias Coord = {Int32, Int32}

  def self.adjacent(grid : Array(Array(Char)), rc : Coord) : Array(Coord)
    r, c = rc
    [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1},
     {r - 1, c + 1}, {r + 1, c - 1}]
      .select {|y, x| y >= 0 && y < grid.size && x >= 0 && x < grid[y].size}
      .to_a
  end

  def self.search(grid : Array(Array(Char)), symbol : Char) : String
    goal = grid.size - 1
    front = Set.new(grid[0]
              .each_with_index
              .select {|s, _| s == symbol}
              .map {|_, i| {0, i}})
    visited = Set(Coord).new
    while !front.empty? && !front.any? {|r, _| r == goal}
      visited |= front
      front = Set.new(front
        .flat_map {|r, c| adjacent(grid, {r, c})}
        .reject {|r, c| visited.includes?({r, c}) || grid[r][c] != symbol})
     end
     front.empty? ? "" : symbol.to_s
  end

  def self.winner(board : Array(String)) : String
    grid = board.map &.gsub(' ', "").chars
    w = search(grid, 'O')
    if w.empty?
       w = search(grid.transpose, 'X')
    end
    w
  end
end
