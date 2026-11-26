using System;
using System.Collections.Generic;

public class Robot
{   
    string _name = RobotCreator.RandomName();
    
    public string Name
    {
        get
        {
            return _name;
        }
    }

    public void Reset()
    {
        _name = RobotCreator.RandomName();
    }
}

public static class RobotCreator {
    public static HashSet<string> robotNamesUsed = new HashSet<string>();

    public static string RandomName() {
        Random rdn = new Random();
        string name;

        do {
            name = RandomLetter() + RandomLetter() + rdn.Next(100, 999).ToString();
        } while (robotNamesUsed.Contains(name));

        robotNamesUsed.Add(name);
        
        return name;
    }

    public static string RandomLetter() => ((char) (new Random()).Next('A', 'Z'+1)).ToString();
}
