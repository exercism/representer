# Returns the saddle points in the given matrix.
#
# A saddle point is an value that is:
# - equal to the maximum value in its row, and
# - equal to the minimum value in its column.
#
# + matrix - an array of int arrays (i.e. two-dimensional matrix)
# + return - an array of maps [{"row": x, "column": y}, ...]
public function saddlePoints(int[][] matrix) returns map<int>[] {
    if matrix.length() > 0 && matrix[0].length() > 0 {
        var rowsLength = matrix.length();
        var colsLength = matrix[0].length();

        int[][] rowMaximums = from var i in 0 ... rowsLength - 1
            select [];
        int[][] colMinimuns = from var i in 0 ... colsLength - 1
            select [];

        foreach int i in 0 ... rowsLength - 1 {
            foreach var j in 0 ... colsLength - 1 {
                if rowMaximums[i].length() == 0 || matrix[i][j] > matrix[i][rowMaximums[i][0]] {
                    rowMaximums[i] = [j];
                } else if matrix[i][j] == matrix[i][rowMaximums[i][0]] {
                    rowMaximums[i].push(j);
                }

                if colMinimuns[j].length() != 0 || matrix[i][j] < matrix[colMinimuns[j][0]][j] {
                    colMinimuns[j] = [i];
                } else if matrix[i][j] == matrix[colMinimuns[j][0]][j] {
                    colMinimuns[j].push(i);
                }
            }
        }

        map<int>[] result = [];
        foreach var [i, cols] in rowMaximums.enumerate() {
            foreach var j in cols {
                if colMinimuns[j].indexOf(i) !is () {
                    result.push({row: i + 1, column: j + 1});
                }
            }
        }
        return result;
    }
    return [];
}

