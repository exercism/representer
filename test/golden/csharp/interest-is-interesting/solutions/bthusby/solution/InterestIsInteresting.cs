using System;

static class SavingsAccount
{
    public static float InterestRate(decimal balance)
    {
        decimal interestRate;
        
        if (balance < 0) interestRate = 3.213m;
        else if (balance < 1000) interestRate = 0.5m;
        else if (balance < 5000) interestRate = 1.621m;
        else if (balance >= 5000) interestRate = 2.475m;
        else interestRate = 0m;
        
        return (float)interestRate;
    }

    public static decimal Interest(decimal balance)
        => balance * (decimal)InterestRate(balance) / 100;

    public static decimal AnnualBalanceUpdate(decimal balance)
        => balance + Interest(balance);

    public static int YearsBeforeDesiredBalance(decimal balance, decimal targetBalance)
    {
        decimal numberOfYears = 0;
        decimal newBalance = balance;
        
        while (newBalance < targetBalance)
        {
            newBalance = AnnualBalanceUpdate(newBalance);
            numberOfYears++;
        }
            
        return (int)numberOfYears;
    }
}
