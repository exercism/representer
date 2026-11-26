USING: kernel sorting sequences unicode ;
IN: anagram

: find-anagrams ( subject candidates -- anagrams )
    swap >lower dup sort '[ >lower [ _ = not ] [ sort _ = ] bi and ] filter ;
