using System;

public static class ReverseString
{
    public static string Reverse(string input)
        => string.Create(input.Length, input, (span, value) => 
            {
                value.AsSpan().CopyTo(span);
                span.Reverse();
            });
}