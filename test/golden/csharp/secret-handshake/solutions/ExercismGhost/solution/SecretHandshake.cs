using System.Collections.Generic;

public static class SecretHandshake
{
    public static string[] Commands(int commandValue)
    {
        var commandList = new List<string>();

        if ((commandValue & 1) != 0) commandList.Add("wink");
        if ((commandValue & 2) != 0) commandList.Add("double blink");
        if ((commandValue & 4) != 0) commandList.Add("close your eyes");
        if ((commandValue & 8) != 0) commandList.Add("jump");
        if ((commandValue & 16) != 0) commandList.Reverse();

        return commandList.ToArray();
    }
}
