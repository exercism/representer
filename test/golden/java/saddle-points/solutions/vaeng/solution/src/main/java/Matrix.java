import java.util.List;
import java.util.Set;
import java.util.HashSet;

class Matrix {
    private List<List<Integer>> matrixValues;

    public Matrix(List<List<Integer>> matrixValues) {
        this.matrixValues = matrixValues;
    }

    private boolean isMaxInRow(int r, int c) {
        int value = matrixValues.get(r).get(c);
        for(int compare : matrixValues.get(r)) {
            if (compare > value) {
                return false;
            }
        }
        return true;
    }

    private boolean isMinInColumn(int r, int c) {
        int value = matrixValues.get(r).get(c);
        for(List<Integer> row : matrixValues) {
            if (row.get(c) < value) {
                return false;
            }
        }
        return true;
    }

    public Set<MatrixCoordinate> getSaddlePoints() {
        Set<MatrixCoordinate> saddlePoints = new HashSet<MatrixCoordinate>();

        for(int i = 0; i < matrixValues.size(); i++) {
            for(int j = 0; j < matrixValues.get(0).size(); j++) {
                if (this.isMaxInRow(i, j) && this.isMinInColumn(i, j)) {
                    saddlePoints.add(new MatrixCoordinate(i+1, j+1));
                }
            } 
        }
        return saddlePoints;
    }
}