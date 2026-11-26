using System.Linq;

        

          

using System.Collections.Generic;

        

          


        

          

public static class SaddlePoints

        

          

{

        

          

    public static IEnumerable<(int, int)> Calculate(int[,] matrix)

        

          

    {

        

          

        var rowIndexer = Enumerable.Range(0, matrix.GetLength(0));

        

          

        var colIndexer = Enumerable.Range(0, matrix.GetLength(1));

        

          


        

          

        var rows = from i in rowIndexer

        

          

            select from j in colIndexer

        

          

            select matrix[i, j];

        

          


        

          

        var cols = from i in colIndexer

        

          

            select from j in rowIndexer

        

          

            select matrix[j, i];

        

          


        

          

        return from i in rowIndexer

        

          

            from j in colIndexer

        

          

            where rows.ElementAt(i).All(x => matrix[i, j] >= x)

        

          

            where cols.ElementAt(j).All(x => matrix[i, j] <= x)

        

          

            select (i + 1, j + 1);

        

          

    }

        

          

}