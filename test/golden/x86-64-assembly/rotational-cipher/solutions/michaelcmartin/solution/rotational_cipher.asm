section .text
global rotate
rotate:
        mov     rcx, rdx        ; Move 3rd arg somewhere handier..,
        xor     edx, edx        ;    ... since DIV needs EDX:EAX
        mov     al, 26
        movsx   eax, al
        xchg    eax, esi        ; Compute EDX % 26...
        div     esi             ;    ... EDX is now the real rot amount
.lp:    mov     al, [rdi]
        sub     al, 'A'         ; Is uppercase?
        cmp     al, 26
        jae     .notupper
        call    .rotate
.notupper:
        sub     al, 'a'-'A'     ; Is lowercase?
        cmp     al, 26
        jae     .next
        call    .rotate
.next:  add     al, 'a'         ; Cancel out our earlier additions
        mov     [rcx], al
        inc     rdi
        inc     rcx
        or      al, al
        jnz     .lp
        ret
.rotate:
        add     al, dl
        cmp     al, 26
        jb      .rdone
        sub     al, 26
.rdone: ret
