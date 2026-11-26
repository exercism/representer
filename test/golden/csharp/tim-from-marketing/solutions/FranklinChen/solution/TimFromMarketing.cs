/// https://exercism.org/tracks/csharp/exercises/tim-from-marketing

using System;

static class Badge
{
    /// Concise but not super readable.
    public static string Print(int? id, string name, string? department) =>
        $"{(id == null? "" : $"[{id}] - ")}{name} - {department?.ToUpper() ?? "OWNER"}";
}
