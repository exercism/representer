using System;
using System.Collections.Generic;

public static class SecretHandshake
{
    public static string[] Commands(int commandValue)
    {
        var output = new List<string>();

        if ((commandValue & 1) != 0)
            output.Add("wink");
        if ((commandValue & 2) != 0)
            output.Add("double blink");
        if ((commandValue & 4) != 0)
            output.Add("close your eyes");
        if ((commandValue & 8) != 0)
            output.Add("jump");

        if ((commandValue & 16) != 0)
            output.Reverse();

        return output.ToArray();
    }
}