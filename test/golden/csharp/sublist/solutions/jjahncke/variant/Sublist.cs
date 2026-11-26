using System;
using System.Collections.Generic;
using System.Linq;

public enum SublistType
{
    Equal,
    Unequal,
    Superlist,
    Sublist
}

public static class Sublist
{
    public static SublistType Classify<T>(List<T> list1, List<T> list2)
        where T : IComparable
    {
        int i;

        if (list1.Count == list2.Count)
        {
            if( list1.SequenceEqual( list2 ))
                return (SublistType.Equal);
        } else if( list1.Count<list2.Count )
        {
            for( i=0; i<( list2.Count-list1.Count-1 ); i++ )
            {
                if( list1.SequenceEqual( list2.GetRange( i, list1.Count )))
                    return (SublistType.Sublist);
            }
         } else
        {
            for (i = 0; i <( list1.Count - list2.Count+1 ); i++)
            {
                if (list2.SequenceEqual(list1.GetRange(i, list2.Count)))
                    return (SublistType.Superlist);
            }

        }
        return (SublistType.Unequal);
    }   
}