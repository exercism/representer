using System;
using System.Collections.Generic;

public static class Strain
{
	public static IEnumerable<T> Keep<T>(this IEnumerable<T> list, Func<T, bool> predicate)
	{
		foreach (var item in list)
		{
			if (predicate(item))
			{
				yield return item;
			}
		}
	}

	public static IEnumerable<T> Discard<T>(this IEnumerable<T> list, Func<T, bool> predicate)
	{
		foreach (var item in list)
		{
			if (!predicate(item))
			{
				yield return item;
			}
		}
	}
}