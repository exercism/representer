#include "food_chain.h"
#include <vector>
using namespace std;

namespace food_chain
{

const vector<string> animals = 
{
    "fly",
    "spider",
    "bird",
    "cat",
    "dog",
    "goat",
    "cow",
    "horse"
};

const vector<string> phrases =
{
    "I don't know why she swallowed the fly. Perhaps she'll die.\n",
    "It wriggled and jiggled and tickled inside her.\n",
    "How absurd to swallow a bird!\n",
    "Imagine that, to swallow a cat!\n",
    "What a hog, to swallow a dog!\n",
    "Just opened her throat and swallowed a goat!\n",
    "I don't know how she swallowed a cow!\n",
    "She's dead, of course!\n"
};

string verse(int number)
{
    string song;

    // First line
    song += "I know an old lady who swallowed a ";
    song += animals[number-1];
    song += ".\n";

    // For middle animals
    if ((number != 1) && (number != 8))
    {
        // Second line.
        song += phrases[number-1];

        // Chain lines.
        for(int n = number; n >= 2; n--)
        {
            song += "She swallowed the ";
            song += animals[n-1];
            song += " to catch the ";
            song += animals[n-2];
            if ((number != 2) && (n == 3))
                song += " that wriggled and jiggled and tickled inside her.\n";
            else
                song += ".\n";
        }
    }

    // Last line.
    if (number == 8)
        song += phrases[7];
    else
        song += phrases[0];
    return song;
}

string verses(int from, int to)
{
    string song;
    for (int n = from; n <= to; n++)
    {
        song += verse(n);
        song += "\n";
    }
    return song;
}

string sing(void)
{
    return verses(1, 8);
}
}  // namespace food_chain
