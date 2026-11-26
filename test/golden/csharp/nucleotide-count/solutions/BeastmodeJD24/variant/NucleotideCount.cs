using System;
using System.Collections.Generic;

public static class NucleotideCount
{
    public static IDictionary<char, int> Count(string sequence)
    {
        IDictionary<char, int> count = new Dictionary<char, int>();
        char[] chrArray = sequence.ToCharArray();
        int a = 0;
        int c = 0;
        int t = 0;
        int g = 0;
        
        for (int i = 0; i <= chrArray.Length; i++)
        {
            //foreach (KeyValuePair<char, int> kvp in count)
            //{
            //    switch (kvp.Key)
            //    {
            //        case chrArray[i]:
            //             newKvp = kvp;
            //        case chrArray[i]:
            //            newKvp = kvp;
            //        case chrArray[i]:
            //            newKvp = kvp;
            //        case chrArray[i]:
            //            newKvp = kvp;
            //        default:
            //            throw new ArgumentException();
            //    }
            //}
            switch (chrArray[i])
            {
                case 'A':
                    a++;
                    break;
                case 'C':
                   c++;
                    break;
                case 'G':
                    g++;
                    break;
                case 'T':
                    t++;
                    break;
                default:
                    throw new ArgumentException();
            }

        }
        count.Add('A', a);
        count.Add('C', c);
        count.Add('G', g);
        count.Add('T', t);
        return count;
    }
}