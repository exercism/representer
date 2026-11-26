using System;

public enum Classification
{
    Perfect,
    Abundant,
    Deficient
}

public static class PerfectNumbers
{
        public static Classification Classify(int number)
        {
            if (number <= 0) throw new ArgumentOutOfRangeException();
            int sum = 1;
            int pow = (int)Math.Sqrt(number);
            int sumCheck = 1;

            for (int i = 2; i <= pow; i++)
            {
                if (number % i == 0)
                {
                    //in from - to
                    sum += i;
                    sumCheck += i;

                    int tofrom = number / i;
                    if (i == tofrom)
                    {
                        sum += tofrom;
                        if (tofrom < number) sumCheck += tofrom;
                    }
                }

                if (sum == number && number != 1) return Classification.Perfect;
                if (sum > number) break;
            }
            if (sumCheck <= number) return Classification.Deficient;
            else return Classification.Abundant;
        }
}
