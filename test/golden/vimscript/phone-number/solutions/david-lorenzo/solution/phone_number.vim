"
" Clean up user-entered phone numbers so that they can be sent SMS messages.
"
" Example:
"
"   :echo ToNANP('+1 (613)-995-0253')
"   6139950253
"
let s:digits = str2list("1234567890")
function! ToNANP(number) abort
    let snumber = list2str(filter(str2list(a:number), "index(s:digits, v:val) >= 0"))
    if snumber[0] == "1"
        let snumber = snumber[1:]
    endif
    if strlen(snumber) != 10 || snumber[0] == "0" || snumber[0] == "1" || snumber[3] == "0"|| snumber[3] == "1"
        let snumber = ""
    endif
    return snumber
endfunction
