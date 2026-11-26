#include "food_chain.h"

using namespace std;

namespace {

string start_intro = "I know an old lady who swallowed a ";

vector<string> animals = {"fly",
    "spider",
    "bird",
    "cat",
    "dog",
    "goat",
    "cow",
    "horse",
    };

vector<string> intros = {"",
    "It wriggled and jiggled and tickled inside her.\n",
    "How absurd to swallow a bird!\n",
    "Imagine that, to swallow a cat!\n",
    "What a hog, to swallow a dog!\n",
    "Just opened her throat and swallowed a goat!\n",
    "I don't know how she swallowed a cow!\n",
    "She's dead, of course!\n"
    };

vector<string> endings = {"I don't know why she swallowed the fly. Perhaps she'll die.\n",
    ".\n",
    " that wriggled and jiggled and tickled inside her.\n",
    ".\n",
    ".\n",
    ".\n",
    ".\n"
    };
}

string food_chain::verse(size_t v)
{
    v--;
    string ret = start_intro + animals[v] + ".\n" + intros[v];
    if (v >= endings.size())
        return ret;
    for (int i = v; i > 0; i--) {
        ret += "She swallowed the " + animals[i] + " to catch the " + animals[i-1] + endings[i];
    }
    ret += endings[0];
    return ret;
}

string food_chain::verses(size_t start, size_t end)
{
    string ret;
    for (size_t i = start; i <= end; i++)
        ret += verse(i) + "\n";
    return ret;
}

string food_chain::sing()
{
    return verses(1, 8);
}
