using System;
using System.Collections.Generic;

public static class SecretHandshake
{
    public static string[] Commands(int n)
    {
        var r = new List<string>();
        if ((n &  1) != 0) r.Add("wink");
        if ((n &  2) != 0) r.Add("double blink");
        if ((n &  4) != 0) r.Add("close your eyes");
        if ((n &  8) != 0) r.Add("jump");
        if ((n & 16) != 0) r.Reverse();
        return r.ToArray();
    }
}
