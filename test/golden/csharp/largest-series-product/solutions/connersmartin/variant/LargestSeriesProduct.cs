using System;
using System.Collections.Generic;
using System.Linq;

public static class LargestSeriesProduct
{
    public static long GetLargestProduct(string digits, int span) 
    {
        var digitLength = digits.Length;

        if (digitLength!=0) return span > 0 ? throw new ArgumentException("Can't do empty") : 1;
        if (digitLength < span) throw new ArgumentException("Span longer than string");
        if (span <= 0) return span == 0 ? 1 : throw new ArgumentException("Span invalid");
        
        var largestProduct = 0;

        for (int i = 0; i <= digitLength-span; i++)
        {
            var total = 1;
            for (int j = 0; j < span; j++)
            {
                var intdex = digits[i + j].ToString();
                if (!int.TryParse(intdex, out int digit)) throw new ArgumentException("Not a valid number");
                total *= digit;
            }
            if (total > largestProduct) largestProduct = total;
        }
        return largestProduct;
    }
}