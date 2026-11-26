function! s:verse(verse) abort
    let l:animals = ['fly', 'spider', 'bird', 'cat', 'dog', 'goat', 'cow', 'horse']
    let l:phrase = [
        \ "I don't know why she swallowed the fly. Perhaps she'll die.",
        \ 'It wriggled and jiggled and tickled inside her.',
        \ 'How absurd to swallow a bird!',
        \ 'Imagine that, to swallow a cat!',
        \ 'What a hog, to swallow a dog!',
        \ 'Just opened her throat and swallowed a goat!',
        \ "I don't know how she swallowed a cow!",
        \ "She's dead, of course!"
        \ ]
    
    let l:NUMBER_MAX = 8
    let l:result = []
    
    if a:verse > 0 && a:verse <= l:NUMBER_MAX
        " Add intro line
        call add(l:result, "I know an old lady who swallowed a " . l:animals[a:verse - 2] . ".")
        " Add reaction line
        call add(l:result, l:phrase[a:verse - 1])
        
        " Build chain of swallows for verses 2-7
        if a:verse > 1 && a:verse < l:NUMBER_MAX
            let l:i = 1
            while l:i < a:verse
                if a:verse - l:i - 1 == 1
                    " Special case for spider
                    call add(l:result, "She swallowed the " . l:animals[a:verse - l:i] . 
                        \ " to catch the " . l:animals[a:verse - l:i - 1] . 
                        \ " that wriggled and jiggled and tickled inside her.")
                else
                    call add(l:result, "She swallowed the " . l:animals[a:verse - l:i] . 
                        \ " to catch the " . l:animals[a:verse - l:i - 1] . ".")
                endif
                let l:i += 1
            endwhile
            " Add final line for non-horse verses
            call add(l:result, l:phrase[0])
        endif
    endif
    
    return l:result
endfunction

"
" Return a list containing the lyrics to `I Know an Old Lady Who Swallowed a Fly`,
" using a verse number to end on and another to start from 
"
function! Recite(endVerse, startVerse)
    " Validate input parameters
    if a:startVerse < 1 || a:endVerse > 8
        return []
    endif
    
    let l:result = []
    
    " Handle single verse case
    if a:startVerse == a:endVerse
        return s:verse(a:startVerse)
    endif
    
    " Handle multiple verses
    for l:verse in range(a:startVerse, a:endVerse)
        let l:verse_lines = s:verse(l:verse)
        call extend(l:result, l:verse_lines)
        
        " Add blank line between verses
        if l:verse != a:endVerse
            call add(l:result, '')
        endif
    endfor
    
    return l:result
endfunction
