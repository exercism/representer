"""Word Search puzzle solver."""

class Point:
    """Represents a coordinate in the grid."""

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y


class WordSearch:
    """Search words in a letter grid."""

    def __init__(self, puzzle):
        self.grid = puzzle
        self.rows = len(puzzle)
        self.cols = len(puzzle[0]) if puzzle else 0

        # 8 directions: (dx, dy)
        self.directions = [
            (1, 0),   # right
            (-1, 0),  # left
            (0, 1),   # down
            (0, -1),  # up
            (1, 1),   # down-right
            (-1, -1), # up-left
            (1, -1),  # up-right
            (-1, 1),  # down-left
        ]

    def search(self, word):
        """Find word in grid and return start/end Points or None."""
        if not self.grid:
            return None

        word_len = len(word)

        for y in range(self.rows):
            for x in range(self.cols):
                for dx, dy in self.directions:
                    if self._matches(word, x, y, dx, dy):
                        end_x = x + dx * (word_len - 1)
                        end_y = y + dy * (word_len - 1)
                        return Point(x, y), Point(end_x, end_y)

        return None

    def _matches(self, word, x, y, dx, dy):
        """Check if word matches starting at (x,y) in direction (dx,dy)."""
        for i in range(len(word)):
            nx = x + dx * i
            ny = y + dy * i

            if (
                nx < 0 or ny < 0 or
                nx >= self.cols or ny >= self.rows or
                self.grid[ny][nx] != word[i]
            ):
                return False

        return True
