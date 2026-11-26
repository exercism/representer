module bottle_song;

import std.string : format;
import std.conv : to;
import std.array : join;
import std.ascii : toUpper;

private pure string stringify(int i, bool capital = false)
{
    string result;
    switch (i)
    {
        case 0:
            result = "no";
            break;
        case 1:
            result = "one";
            break;
        case 2:
            result = "two";
            break;
        case 3:
            result = "three";
            break;
        case 4:
            result = "four";
            break;
        case 5:
            result = "five";
            break;
        case 6:
            result = "six";
            break;
        case 7:
            result = "seven";
            break;
        case 8:
            result = "eight";
            break;
        case 9:
            result = "nine";
            break;
        case 10:
            result = "ten";
            break;
        default:
            throw new Exception("Invalid number");
    }
    
    if (capital)
    {
        result = toUpper(result[0]) ~ result[1..$];
    }
    return result;
}

pure string recite(int startBottles, int takeDown)
{
    string result;
    for (; takeDown > 0; --takeDown, --startBottles)
    {
        if (result.length > 0)
        {
            result ~= "\n\n";
        }
        
        int sum = startBottles - 1;
        string sStartBottles = stringify(startBottles, true);
        string sSum = stringify(sum);
        
        result ~= format("%s green bottle%s hanging on the wall,\n" ~
                        "%s green bottle%s hanging on the wall,\n" ~
                        "And if one green bottle should accidentally fall,\n" ~
                        "There'll be %s green bottle%s hanging on the wall.",
                        sStartBottles, startBottles > 1 ? "s" : "",
                        sStartBottles, startBottles > 1 ? "s" : "",
                        sSum, sum == 0 || sum > 1 ? "s" : "");
    }
    return result;
}

unittest
{
    immutable int allTestsEnabled = 0;

    // Verse-single verse-first generic verse
    {
        string expected =
            "Ten green bottles hanging on the wall,\n" ~
            "Ten green bottles hanging on the wall,\n" ~
            "And if one green bottle should accidentally fall,\n" ~
            "There'll be nine green bottles hanging on the wall.";
        assert(recite(10, 1) == expected);
    }

    static if (allTestsEnabled)
    {
        // Verse-single verse-last generic verse
        {
            string expected =
                "Three green bottles hanging on the wall,\n" ~
                "Three green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be two green bottles hanging on the wall.";
            assert(recite(3, 1) == expected);
        }

        // Verse-single verse-verse with 2 bottles
        {
            string expected =
                "Two green bottles hanging on the wall,\n" ~
                "Two green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be one green bottle hanging on the wall.";
            assert(recite(2, 2) == expected);
        }

        // Verse-single verse-verse with 1 bottle
        {
            string expected =
                "One green bottle hanging on the wall,\n" ~
                "One green bottle hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be no green bottles hanging on the wall.";
            assert(recite(1, 1) == expected);
        }

        // Lyrics-multiple verses-first two verses
        {
            string expected =
                "Ten green bottles hanging on the wall,\n" ~
                "Ten green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be nine green bottles hanging on the wall.\n" ~
                "\n" ~
                "Nine green bottles hanging on the wall,\n" ~
                "Nine green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be eight green bottles hanging on the wall.";
            assert(recite(10, 2) == expected);
        }

        // Lyrics-multiple verses-last three verses
        {
            string expected =
                "Three green bottles hanging on the wall,\n" ~
                "Three green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be two green bottles hanging on the wall.\n" ~
                "\n" ~
                "Two green bottles hanging on the wall,\n" ~
                "Two green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be one green bottle hanging on the wall.\n" ~
                "\n" ~
                "One green bottle hanging on the wall,\n" ~
                "One green bottle hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be no green bottles hanging on the wall.";
            assert(recite(3, 3) == expected);
        }

        // Lyrics-multiple verses-all verses
        {
            string expected =
                "Ten green bottles hanging on the wall,\n" ~
                "Ten green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be nine green bottles hanging on the wall.\n" ~
                "\n" ~
                "Nine green bottles hanging on the wall,\n" ~
                "Nine green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be eight green bottles hanging on the wall.\n" ~
                "\n" ~
                "Eight green bottles hanging on the wall,\n" ~
                "Eight green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be seven green bottles hanging on the wall.\n" ~
                "\n" ~
                "Seven green bottles hanging on the wall,\n" ~
                "Seven green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be six green bottles hanging on the wall.\n" ~
                "\n" ~
                "Six green bottles hanging on the wall,\n" ~
                "Six green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be five green bottles hanging on the wall.\n" ~
                "\n" ~
                "Five green bottles hanging on the wall,\n" ~
                "Five green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be four green bottles hanging on the wall.\n" ~
                "\n" ~
                "Four green bottles hanging on the wall,\n" ~
                "Four green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be three green bottles hanging on the wall.\n" ~
                "\n" ~
                "Three green bottles hanging on the wall,\n" ~
                "Three green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be two green bottles hanging on the wall.\n" ~
                "\n" ~
                "Two green bottles hanging on the wall,\n" ~
                "Two green bottles hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be one green bottle hanging on the wall.\n" ~
                "\n" ~
                "One green bottle hanging on the wall,\n" ~
                "One green bottle hanging on the wall,\n" ~
                "And if one green bottle should accidentally fall,\n" ~
                "There'll be no green bottles hanging on the wall.";
            assert(recite(10, 10) == expected);
        }
    }
}
