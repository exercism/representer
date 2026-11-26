using System;

public static class PhoneNumber
{
    public static (bool IsNewYork, bool IsFake, string LocalNumber) Analyze(string phoneNumber)
    {
        string[] code = phoneNumber.Split("-"); 
        return ((code[0]=="212"),(code[1]=="555"),code[2]);
        throw new NotImplementedException($"Please implement the (static) PhoneNumber.Analyze() method");
    }

    public static bool IsFake((bool IsNewYork, bool IsFake, string LocalNumber) phoneNumberInfo)
    {        
        return (phoneNumberInfo.Item2);
        throw new NotImplementedException($"Please implement the (static) PhoneNumber.IsFake() method");
    }
}
