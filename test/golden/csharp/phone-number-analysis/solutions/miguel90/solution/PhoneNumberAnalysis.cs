using System;

public static class PhoneNumber
{
    public static (bool IsNewYork, bool IsFake, string LocalNumber) Analyze(string phoneNumber)
    {      
        (bool newY, bool fake, string local) values = (false, false, "");
        string[] number = phoneNumber.Split("-");
        
        if(number[0].Equals("212")){
            values.newY = true;
        }
        else{
            values.newY = false;
        }

        if(number[1].Equals("555")){
            values.fake = true;
        }
        else {
            values.fake = false;
        }

        if(number[2].Length == 4){
            values.local = number[2];
        } 
        
        return values;
    }

    public static bool IsFake((bool IsNewYork, bool IsFake, string LocalNumber) phoneNumberInfo)
    {
        if(phoneNumberInfo.IsFake == true){
            return phoneNumberInfo.IsFake;
        }
        else {
            return false;
        }   
    }
}
