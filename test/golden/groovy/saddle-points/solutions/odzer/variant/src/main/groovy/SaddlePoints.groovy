class SaddlePoints {

    static ArrayList<ArrayList<Integer>> getSaddlePoints(ArrayList<ArrayList<Integer>> matrix) {
        def saddlePoints = new ArrayList()
        if (matrix.size() == 0) {
            return saddlePoints
        }

        def rowMaxes = new int[matrix.size()]
        def colMins = new int[matrix.get(0).size()]
        Arrays.fill(colMins, Integer.MAX_VALUE)
        Arrays.fill(rowMaxes, Integer.MIN_VALUE)

        matrix.eachWithIndex { ArrayList<Integer> row, int rowIndex ->
            row.eachWithIndex { int current, int colIndex ->
                if (current >= rowMaxes[rowIndex]) {
                    rowMaxes[rowIndex] = current
                }
                if (current <= colMins[colIndex]) {
                    colMins[colIndex] = current
                }
            }
        }

        matrix.eachWithIndex { ArrayList<Integer> row, int rowIndex ->
            row.eachWithIndex { int current, int colIndex ->
                if (current == colMins[colIndex] && current != rowMaxes[rowIndex]) {
                    saddlePoints.add([rowIndex, colIndex])
                }
            }
        }

        return saddlePoints;
    }
}
