using System;
using System.Collections.Generic;
using System.Linq;

[Flags]
public enum Allergen
{
    Eggs = 1,
    Peanuts = 2,
    Shellfish = 4,
    Strawberries = 8,
    Tomatoes = 16,
    Chocolate = 32,
    Pollen = 64,
    Cats = 128
}

public class Allergies
{

    private readonly Allergen mask;
    public Allergies(int _mask)
    {
        mask = (Allergen)_mask;
    }

    public bool IsAllergicTo(Allergen allergen)
    {
        return mask.HasFlag(allergen);
    }

    public Allergen[] List()
    {
        //var list = new List<Allergen>();
        //foreach (Allergen al in Enum.GetValues(typeof(Allergen)))
        //    if (IsAllergicTo(al))
        //        list.Add(al);
        //return list.ToArray();

        return Enum.GetValues(typeof(Allergen)).Cast<Allergen>().Where(al => IsAllergicTo(al)).ToArray();
    }
}