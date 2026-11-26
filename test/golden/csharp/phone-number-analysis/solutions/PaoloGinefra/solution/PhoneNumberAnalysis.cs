using System;

public static class PhoneNumber
{
    static int NYPr = 212;
    static int FakePr = 555;
    public static (bool IsNewYork, bool IsFake, string LocalNumber) Analyze(string phoneNumber)
    {
        string[] splittedNumber = phoneNumber.Split('-');
        return (splittedNumber[0] == PhoneNumber.NYPr.ToString(),
                splittedNumber[1] == (string)PhoneNumber.FakePr.ToString(),
                splittedNumber[2]
                );
    }

    public static bool IsFake((bool IsNewYork, bool IsFake, string LocalNumber) phoneNumberInfo)
    {
        return phoneNumberInfo.IsFake;
    }
}
