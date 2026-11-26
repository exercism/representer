using System;
using System.Diagnostics.CodeAnalysis;

public struct CurrencyAmount
{
    private decimal amount;
    private string currency;

    public CurrencyAmount(decimal amount, string currency)
    {
        this.amount = amount;
        this.currency = currency;
    }

    public override bool Equals([NotNullWhen(true)] object obj)
    {
        CurrencyAmount compare = (CurrencyAmount) obj;
        if (currency != compare.currency)
        {
            throw new ArgumentException();
        }
        return compare.amount == amount;
    }

    public override int GetHashCode()
    {
        return HashCode.Combine(amount, currency);
    }

    public static bool operator ==(CurrencyAmount objA, CurrencyAmount objB)
    {
        if (objA.currency != objB.currency)
        {
            throw new ArgumentException();
        }
        return objA.amount == objB.amount;
    }

    public static bool operator !=(CurrencyAmount objA, CurrencyAmount objB)
    {
        if (objA.currency != objB.currency)
        {
            throw new ArgumentException();
        }
        return objA.amount != objB.amount;
    }

    public static bool operator >(CurrencyAmount objA, CurrencyAmount objB)
    {
        if (objA.currency != objB.currency)
        {
            throw new ArgumentException();
        }
        return objA.amount > objB.amount;
    }

    public static bool operator <(CurrencyAmount objA, CurrencyAmount objB)
    {
        if (objA.currency != objB.currency)
        {
            throw new ArgumentException();
        }
        return objA.amount < objB.amount;
    }

    public static CurrencyAmount operator +(CurrencyAmount objA, CurrencyAmount objB)
    {
        if (objA.currency != objB.currency)
        {
            throw new ArgumentException();
        }
        return new CurrencyAmount { currency = objA.currency, amount = objA.amount + objB.amount};
    }

    public static CurrencyAmount operator -(CurrencyAmount objA, CurrencyAmount objB)
    {
        if (objA.currency != objB.currency)
        {
            throw new ArgumentException();
        }
        return new CurrencyAmount { currency = objA.currency, amount = objA.amount - objB.amount };
    }

    public static CurrencyAmount operator *(decimal value, CurrencyAmount obj)
    {
        return new CurrencyAmount { currency = obj.currency, amount = value * obj.amount };
    }

    public static CurrencyAmount operator *(CurrencyAmount obj, decimal value)
    {
        return new CurrencyAmount { currency = obj.currency, amount = value * obj.amount };
    }

    public static CurrencyAmount operator /(CurrencyAmount obj, decimal value)
    {
        return new CurrencyAmount { currency = obj.currency, amount = obj.amount / value };
    }

    public static explicit operator double(CurrencyAmount a) => (double)a.amount;
    public static implicit operator decimal(CurrencyAmount a) => a.amount;
}
