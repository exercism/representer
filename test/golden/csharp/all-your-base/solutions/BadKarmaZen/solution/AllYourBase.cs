using System;
using System.Linq;

public static class AllYourBase
{
    public static int[] Rebase(int inputBase, int[] inputDigits, int outputBase)
    {
        if (inputBase <= 1 || outputBase <= 1) throw new ArgumentException();
        int Validate(int digit) => (digit >= inputBase || digit < 0) ? throw new ArgumentException() : digit;
        
        int Unbase() => inputDigits.Reverse().Select((d, i) => Validate(d) * (int)Math.Pow(inputBase, i)).Sum();
        
        int[] Rebase(int value) => ((value < outputBase) ? new int[0] : Rebase(value / outputBase)).Append(value % outputBase).ToArray();

        return Rebase(Unbase());
    }
}
