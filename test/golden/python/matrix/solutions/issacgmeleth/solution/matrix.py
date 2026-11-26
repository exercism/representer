class Matrix:

    def __init__(self, matrix_string):
        self.m = [[int(j) for j in x.split()] for x in matrix_string.split('\n') ]

    def row(self, index):
        return self.m[index-1]

    def column(self, index):
        return [col[index-1] for col in self.m]
