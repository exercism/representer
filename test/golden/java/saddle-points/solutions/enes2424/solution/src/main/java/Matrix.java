import java.util.*;

class Matrix {
    private List<List<Integer>> values;
    
    Matrix(List<List<Integer>> values) {
        this.values = values;
    }

    Set<MatrixCoordinate> getSaddlePoints() {
        Set<MatrixCoordinate> getSaddlePoints = new HashSet<MatrixCoordinate>();
        for (int i = 0; i < values.size(); i++) {
            for (int j = 0; j < values.get(i).size(); j++) {
                if (isSaddlePoints(i, j)) getSaddlePoints.add(new MatrixCoordinate(i + 1, j + 1));
            }
        }
        return getSaddlePoints;
    }

    private boolean isSaddlePoints(int rowIndex, int columnIndex) {
        int x = values.get(rowIndex).get(columnIndex);
        for (int i = 0; i < values.size(); i++) {
            if (i != rowIndex && values.get(i).get(columnIndex) < x) return false;
        }
        for (int j = 0; j < values.get(0).size(); j++) {
            if (j != columnIndex && values.get(rowIndex).get(j) > x) return false;
        }
        return true;
    }
}
