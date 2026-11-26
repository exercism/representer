using System;
using System.Collections.Generic;

public static class PascalsTriangle
{
    public static IEnumerable<IEnumerable<int>> Calculate(int rows)
    {
        List<List<int>> pascaltriangle = new List<List<int>>();
        for (int i = 0; i < rows; i++)
            {
                List<int> row = new List<int>();
                List<int> GeciciRow = new List<int>(); // Gecici bir liste alıyoruz , biraz sonra kullanacağımız for döngüsünde , geçerli listeyi kaydetmek için

                for (int j = 0; j <= i; j++)
                {
                    if (j == 0 || j == i)
                    {
                        row.Add(1);
                        GeciciRow.Add(1);
                    }
                    else
                    {
                        int sum = 0;
                        if (i > 0)
                        {
                            var previousRow = pascaltriangle[i - 1];
                            sum = previousRow[j - 1] + previousRow[j];
                        }
                        row.Add(sum);
                        GeciciRow.Add(sum);
                    }
                }

                pascaltriangle.Add(GeciciRow); 
                yield return row;
    }
}}