using System;

public static class BeerSong
{
    public static string Recite(int startBottles, int takeDown)
    {
        string lyrics = "";
        int i = startBottles;
        while(i > startBottles - takeDown)
        {
            string bottles = i == 1 ? $"bottle" : "bottles";
            string count = i > 0 ? i.ToString() : "No more";
            lyrics += $"{count} {bottles} of beer on the wall, {count.ToLower()} {bottles} of beer.\n";
            i--;
            bottles = i == 1 ? $"bottle" : "bottles";
            count = i > 0 ? i.ToString() : "no more";
            string one = i > 0 ? "one" : "it";
            lyrics += i >= 0 ? $"Take {one} down and pass it around, {count} {bottles} of beer on the wall." : "Go to the store and buy some more, 99 bottles of beer on the wall.";
            lyrics += "\n\n";
        }
        return lyrics.TrimEnd();
    }
}