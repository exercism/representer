package anagram

import "core:slice"
import "core:mem"
import "core:strings"
import "core:unicode"
import "core:unicode/utf8"

MAX_RUNES :: 64

to_runes :: proc(str: string, slc:[]rune) -> (res : []rune) {
    i := 0
    for c in str do slc[i], i = unicode.to_lower(c), i+1
    
    slice.sort(slc[:i])
    res = slc[:i] // err is .None
    return
}


find_anagrams:: proc(word: string, candidates: []string) ->
                    (r: []string , err: mem.Allocator_Error)#optional_allocator_error {
    word_len := strings.rune_count(word)
    if word_len > MAX_RUNES do return // Word too big for stack buffer
    word_buf : [MAX_RUNES]rune
    cand_buf : [MAX_RUNES]rune
    sorted_lc_word := to_runes(word,word_buf[:]) 
    
    result := make([dynamic]string) or_return

    for cand in candidates {
        if strings.rune_count(cand) != strings.rune_count(word) do continue
        i, w := 0, word
        for c in cand {
            r, size := utf8.decode_rune(w)
            if unicode.to_lower(c) != unicode.to_lower(r) do break
            i,w = i+1, w[size:]
        }
        if i == strings.rune_count(word) do continue
        sorted_lc_cand := to_runes(cand,cand_buf[:])

        if slice.equal(sorted_lc_cand, sorted_lc_word) {
            append(&result, cand) or_return
        }    
    }
    r = result[:]
    return 
}