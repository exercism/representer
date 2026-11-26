"
" Clean up user-entered phone numbers so that they can be sent SMS messages.
"
" Example:
"
"   :echo ToNANP('+1 (613)-995-0253')
"   6139950253
"
"  (country code == 1)[1]? (area code)[3] (exchange code)[3] (subscriber number)[4]

function! ToNANP(number) abort
    if a:number =~ '\a' || (a:number[0] != '+' && a:number =~ '\V+') || a:number =~ '[^0-9 ().\-+]'
        return ''
    endif
    let number = substitute(a:number, '\D', '', 'g')
    if strlen(number) == 10
        let ret = number
    elseif strlen(number) == 11
        if number[0] == '1'
            let ret = number[1:]
        else
            return ''
        endif
    else
        return ''
    endif
    if ret[0] !~ '[2-9]' || ret[3] !~ '[2-9]'
        return ''
    else
        return ret
    endif
endfunction