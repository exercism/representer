using System;

public static class TwelveDays
{
    private static (string Day, string Gift)[] _dayGiftPairs = {
    ("first", "a Partridge in a Pear Tree."),
    ("second", "two Turtle Doves"),
    ("third", "three French Hens"),
    ("fourth", "four Calling Birds"),
    ("fifth", "five Gold Rings"),
    ("sixth", "six Geese-a-Laying"),
    ("seventh", "seven Swans-a-Swimming"),
    ("eighth", "eight Maids-a-Milking"),
    ("ninth", "nine Ladies Dancing"),
    ("tenth", "ten Lords-a-Leaping"),
    ("eleventh", "eleven Pipers Piping"),
    ("twelfth", "twelve Drummers Drumming")
  };

  public static string Recite(int verseNumber)
  {
    if (verseNumber < 1 || verseNumber > 12)
      throw new ArgumentOutOfRangeException(nameof(verseNumber), $"{nameof(verseNumber)} must be between 1 and 12 inclusively.");
    return $"On the {_dayGiftPairs[verseNumber - 1].Day} day of Christmas my true love gave to me:{GetRecursiveVerse(verseNumber)}";
  }

  public static string Recite(int startVerse, int endVerse)
  {
    if (startVerse < 1 || startVerse > 12)
      throw new ArgumentOutOfRangeException(nameof(startVerse), $"{nameof(startVerse)} must be between 1 and 12 inclusively.");
    else if (endVerse < 1 || endVerse > 12)
      throw new ArgumentOutOfRangeException(nameof(endVerse), $"{nameof(endVerse)} must be between 1 and 12 inclusively.");
    else if (startVerse > endVerse)
      throw new ArgumentException($"{nameof(startVerse)} must be less or equal to {nameof(endVerse)}.");
    else if (startVerse == endVerse)
      return Recite(startVerse);
    System.Text.StringBuilder sb = new();
    for (int i = startVerse; i <= endVerse; i++)
      if (i != endVerse)
        sb.Append(Recite(i)).AppendLine();
      else 
        sb.Append(Recite(i));
    return sb.ToString();
  }

  private static string GetRecursiveVerse(int verseNumber)
  {
    var sourceVerseNumber = verseNumber - 1;
    return (sourceVerseNumber == 0)
      ? $" {_dayGiftPairs[sourceVerseNumber].Gift}"
      : (sourceVerseNumber == 1)
        ? $" {_dayGiftPairs[sourceVerseNumber].Gift}, and{GetRecursiveVerse(sourceVerseNumber)}"
        : $" {_dayGiftPairs[sourceVerseNumber].Gift},{GetRecursiveVerse(sourceVerseNumber)}";
  }
}