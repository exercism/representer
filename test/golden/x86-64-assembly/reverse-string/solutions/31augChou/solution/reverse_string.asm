        section .text
        global  reverse
reverse:
        ;; Point rsi to the end of the string
        mov     rsi, rdi
.endlp: lodsb
        or      al, al
        jnz     .endlp
        sub     rsi, 2          ; Rewind past the null byte.
        ;; Main loop ends when the pointers cross.
.lp:    cmp     rdi, rsi
        jae     .done
        mov     cl, [rdi]
        mov     al, [rsi]
        mov     [rsi], cl
        dec     rsi
        stosb
        jmp     .lp
.done:  ret