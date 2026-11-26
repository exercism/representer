using System;

public static class CollatzConjecture
{
    public static int Steps(int number)
    {
        if (number <= 0) {
            throw new ArgumentOutOfRangeException();
        }
        return CountSteps(number);
    }

    private static int CountSteps(int number, int steps = 0) {
        if (number == 1) {
            return steps;
        }
        steps++;
        if (number % 2 != 0) {
            return CountSteps(number / 2, steps);
        } else {
            return CountSteps(number * 3 + 1, steps);
        }
    }
}