using System.Collections.Generic;
using System.Linq;

/*
 * Given a number, find the sum of all the unique multiples of particular numbers up to but not including that number.
 * If we list all the natural numbers below 20 that are multiples of 3 or 5, we get 3, 5, 6, 9, 10, 12, 15, and 18.
 * The sum of these multiples is 78.
 */
public static class SumOfMultiples
{
    public static int Sum(IEnumerable<int> multiples, int max) => Enumerable.Range(0, max).Where(x => multiples.Any(i => i != 0 && x % i == 0)).Sum();
}