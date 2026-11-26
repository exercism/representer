def recite(start_verse, end_verse):

    start_lines = [
        "I know an old lady who swallowed a fly.",
        "I know an old lady who swallowed a spider.",
        "I know an old lady who swallowed a bird.",
        "I know an old lady who swallowed a cat.",
        "I know an old lady who swallowed a dog.",
        "I know an old lady who swallowed a goat.",
        "I know an old lady who swallowed a cow.",
    ]
    animal_lines = [
        "She swallowed the spider to catch the fly.",
        "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.",
        "She swallowed the cat to catch the bird.",
        "She swallowed the dog to catch the cat.",
        "She swallowed the goat to catch the dog.",
        "She swallowed the cow to catch the goat.",
        "I know an old lady who swallowed a cow.",
    ]
    description_lines = [
        "I don't know why she swallowed the fly. Perhaps she'll die.",
        "It wriggled and jiggled and tickled inside her.",
        "How absurd to swallow a bird!",
        "Imagine that, to swallow a cat!",
        "What a hog, to swallow a dog!",
        "Just opened her throat and swallowed a goat!",
        "I don't know how she swallowed a cow!",
    ]

    # making list of verse numbers

    verses = []
    for i in range(start_verse - 1, end_verse):
        verses.append(i)

    # removing verse 8

    if 7 in verses:
        verses.remove(7)

    # adding to output

    output = []
    for e in verses:
        output.append(start_lines[e])
        output.append(description_lines[e])
        for i in range(e, 0, -1):
            output.append(animal_lines[i - 1])
        if e != 0:
            output.append(description_lines[0])
        output.append("")

    # adding verse 8

    if end_verse == 8:
        output.append("I know an old lady who swallowed a horse.")
        output.append("She's dead, of course!")
    
    # removing extra elements at end
    
    if output[-1] == "":
        output = output[:-1]
    return output