using System;
using System.Collections.Generic;
using System.Threading;

public static class AccumulateExtensions
{
    public static IEnumerable<Tresultado> Accumulate<Torigem, Tresultado>(this IEnumerable<Torigem> collection, Func<Torigem, Tresultado> func)
    {
        foreach (var item in collection)
        {
            yield return func(item);
        }
    }
}