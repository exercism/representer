module acronym;

import std.stdio;
import std.algorithm;
import std.array;
import std.uni;
import std.conv : to;

string abbreviate(string phrase)
{
    string res;
    bool newWord = true;

    foreach (dchar c; phrase)
    {
        if (isAlpha(c))
        {
            if (newWord)
                res ~= to!string(toUpper(c));

            newWord = false;
        }
        else if (c == '\'')
        {
            // Apostrophes don't start new words
        }
        else
        {
            newWord = true;
        }
    }

    return res;
}

unittest
{
    immutable int allTestsEnabled = 1;

    // Basic
    {
        string phrase = "Portable Network Graphics";
        assert(abbreviate(phrase) == "PNG");
    }

    static if (allTestsEnabled)
    {
        // Lowercase words
        {
            string phrase = "Ruby on Rails";
            assert(abbreviate(phrase) == "ROR");
        }

        // Punctuation
        {
            string phrase = "First In, First Out";
            assert(abbreviate(phrase) == "FIFO");
        }

        // All caps word
        {
            string phrase = "GNU Image Manipulation Program";
            assert(abbreviate(phrase) == "GIMP");
        }

        // Punctuation without whitespace
        {
            string phrase = "Complementary metal-oxide semiconductor";
            assert(abbreviate(phrase) == "CMOS");
        }

        // Very long abbreviation
        {
            string phrase = "Rolling On The Floor Laughing So Hard That My Dogs Came Over And Licked Me";
            assert(abbreviate(phrase) == "ROTFLSHTMDCOALM");
        }

        // Consecutive delimiters
        {
            string phrase = "Something - I made up from thin air";
            assert(abbreviate(phrase) == "SIMUFTA");
        }

        // Apostrophes
        {
            string phrase = "Halley's Comet";
            assert(abbreviate(phrase) == "HC");
        }

        // Underscore emphasis
        {
            string phrase = "The Road _Not_ Taken";
            assert(abbreviate(phrase) == "TRNT");
        }
    }
}
