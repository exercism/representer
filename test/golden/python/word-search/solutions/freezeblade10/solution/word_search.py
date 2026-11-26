class Point:
    def __init__(self, x, y):
        self.x = None
        self.y = None

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y


class WordSearch:
    def __init__(self, puzzle):
        self.puzzle = puzzle


    def diagonal_iter(self, direction):
        self.combi += self.puzzle[self.row][self.col]
        self.combi_dict.update({self.puzzle[self.row][self.col]: (self.col,self.row)})
        if direction == "down":
            self.row += 1
        elif direction == "up":
            self.row -= 1
        self.col += 1

    def reset(self, starting_row, starting_col):
        self.row = self.puzzle.index(starting_row)
        self.col = starting_col
        self.combi = ""
        self.combi_dict = {}
        
    def search(self, word):
        max_cols = len(max(self.puzzle, key=len))
        max_rows = len(self.puzzle)
        # Horizontal search only
        for layer in self.puzzle:
            ind = self.puzzle.index(layer)
            if word in layer or word in layer[::-1]:
                first_col = layer.index(word[0])
                last_col = layer.index(word[-1])
                return Point(first_col, ind), Point(last_col, ind)

        # Vertical search only
        for c in range(max_cols):
            combi = ""
            for layer in self.puzzle:
                combi += layer[c]
            if word in combi or word in combi[::-1]:
                first_row = combi.index(word[0])
                last_row = combi.index(word[-1])
                return Point(c, first_row), Point(c, last_row)
        
        # Top Left-Bottom Right diagonal search
        for layer in self.puzzle[::-1]:
            for c in range(max_cols):
                self.reset(layer,c)
                while self.row <= max_rows-1 and self.col <= max_cols-1:
                    self.diagonal_iter("down")
                if word in self.combi or word in self.combi[::-1]:
                    fcol, frow = self.combi_dict[word[0]][0], self.combi_dict[word[0]][1]
                    lcol, lrow = self.combi_dict[word[-1]][0], self.combi_dict[word[-1]][1]
                    return Point(fcol, frow), Point(lcol, lrow)
        
        # Top Right-Bottom Left diagonal search
        for layer in self.puzzle[::-1]:
            for c in range(max_cols):
                self.reset(layer,c)
                while self.row >= 0 and self.col <= max_cols-1:
                    self.diagonal_iter("up")
                if word in self.combi or word in self.combi[::-1]:
                    fcol, frow = self.combi_dict[word[0]][0], self.combi_dict[word[0]][1]
                    lcol, lrow = self.combi_dict[word[-1]][0], self.combi_dict[word[-1]][1]
                    return Point(fcol, frow), Point(lcol, lrow)


            

       