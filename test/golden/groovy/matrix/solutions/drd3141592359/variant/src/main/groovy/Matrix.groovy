class Matrix {

    int[][] values
    int num_rows, num_columns

    Matrix(String asString) {
        List<String> rows = seperateRows(asString);
        num_rows = rows.size()
        num_columns = rowLength(rows.get(0))
        fillMatrix(rows)


        /*def r = Math.sqrt(asString.length())
        def columns = (r+0.9999)
        def rows = (asString.length()/columns+0.9999)
        values = new int[rows][columns]
        for (def i= 0; i<asString.length(); i++) {
            int a = i/rows
            int b = i%columns
            if (i<asString.length()) values[a][b] = asString.charAt(i)-48
            else values[a][b] = -1
        }*/
    }

    def fillMatrix(List<String> rows) {
        values = new int[num_rows][num_columns]
        for (def i = 0; i < rows.size(); i++) {
            int[] singleRow = rowElements(rows.get(i))
            println singleRow.length+ " " +num_columns
            if (singleRow.length!=num_columns)
                throw new ArithmeticException("Zeilen unterschiedlicher Länge.")
            for (def j = 0; j < singleRow.length; j++)
                values[i][j] = singleRow[j]
        }
    }

    static int rowLength(String rowString) {
        def length= 1
        for (def i=0;i < rowString.length(); i++)
            if (rowString.charAt(i) == ' ')
                length++
        length
    }

    static List<String> seperateRows(String s) {
        List<String> list = new ArrayList<String>()
        def start = 0;
        for (def i=0; i<=s.length(); i++) {
            if (i==s.length())
                list.add(s.substring(start, i))
            else if (s.charAt(i) == '\n') {
                list.add(s.substring(start, i))
                start = i-1
            }
        }
        list
    }

    static int[] rowElements(String rowString) {
        List<String> list = new LinkedList<String>()
        def start = 0
        for (def i=0;i <= rowString.length(); i++) {
            if (i==rowString.length())
                list.add(rowString.substring(start, i))
            else if (rowString.charAt(i) == ' ') {
                list.add(rowString.substring(start, i))
                start = i+1
            }
        }
        int[] elements = new int[list.size()];
        for (def i = 0;i < list.size(); i++)
            elements[i] = Integer.parseInt(list.get(i))
        elements
    }

    int[] row(int rowNumber) {
        values[rowNumber]
    }

    int[] column(int columnNumber) {
        int[] c = new int[num_rows]
        for (def i= 0; i<num_rows; i++)
            c[i] = values[i][columnNumber]
        c
    }
}
