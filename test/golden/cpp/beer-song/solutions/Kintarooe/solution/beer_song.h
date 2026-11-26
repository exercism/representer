#if !defined(BEER_SONG_H)
#define BEER_SONG_H
#include <string>

namespace beer_song {
    std::string verse (int verseNb);
    std::string sing(int from, int to = 0);

    const std::string Bottles {" bottles of beer"};
    const std::string Bottle {" bottle of beer"};
    const std::string Wall {" on the wall"};
    const std::string Pass {"down and pass it around"};
    const std::string Take {"Take"};
    const std::string Store {"Go to the store and buy some more"};
    const std::string Eol {".\n"};

}  // namespace beer_song

#endif // BEER_SONG_H
