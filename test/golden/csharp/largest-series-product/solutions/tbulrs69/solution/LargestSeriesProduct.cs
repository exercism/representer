using System;
using System.Text.RegularExpressions;


public static class LargestSeriesProduct
{
    public static long GetLargestProduct(string digits, int span) 
    {
        if (span == 0 && String.IsNullOrEmpty(digits)){
            return 1;
        }
        if (span > digits.Length || !Regex.IsMatch(digits, @"^\d+$") || span < 0){
            throw new System.ArgumentException();
        }
        
        long best = Int64.MinValue;
        for (int i = 0;i<digits.Length - span + 1;i++){
            long product = 1;
            foreach (char c in (digits.Substring(i,span))){
                product *= int.Parse(c.ToString());
            }
            best = Math.Max(best,product);
        }
        return best;
        
    }
}