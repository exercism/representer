default rel

section .rodata
beg: db "One for "
you: db "you", 0
end: db ", one for me.", 0

section .text
global two_fer

copystr:
    cmp BYTE [rdi], 0
    je copystr_end
copystr_beg:
    mov dl, [rdi]
    mov [rsi], dl
    inc rsi
    inc rdi
    cmp BYTE [rdi], 0
    jne copystr_beg
copystr_end:
    ret


two_fer:
    ; Copy "One for " and move the output pointer
    mov rdx, [beg]
    mov [rsi], rdx
    add rsi, 8

    ; If the first argument is NULL, point it to "you"
    cmp rdi, 0
    jne copyname
    lea rdi, [you]

copyname:
    call copystr

ending:
    ; Load the address for ", one for me."
    lea rdi, [end]
    call copystr

finish:
    mov BYTE [rsi], 0
    ret
