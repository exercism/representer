using System;

public static class CentralBank
{
    public static string DisplayDenomination(long @base, long multiplier)
    {
        try
        {
            checked
            {
                return (@base * multiplier).ToString();
            }
        }
        catch (OverflowException)
        {
            return "*** Too Big ***";
        }
    }

    public static string DisplayGDP(float @base, float multiplier)
    {
        var value = @base * multiplier;
        return value is not float.PositiveInfinity ? value.ToString() : "*** Too Big ***";
    }

    public static string DisplayChiefEconomistSalary(decimal salaryBase, decimal multiplier)
    {
        try
        {
            return $"{salaryBase * multiplier}";
        }
        catch (OverflowException)
        {
            return "*** Much Too Big ***";
        }
    }
}