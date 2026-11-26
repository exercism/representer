def find_anagrams(word, candidates):
    return [
        item for item in candidates
        if item.casefold() != word.casefold()
        and sorted(item.casefold()) == sorted(word.casefold())
    ]