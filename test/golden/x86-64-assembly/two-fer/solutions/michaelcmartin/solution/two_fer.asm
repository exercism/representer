        default rel
        
        section .text
        global two_fer

mystrcat:
        ;; Make sure our copy operations go forward
        cld
        ;; Skip to end of dest
        xchg    rdi, rsi
.suflp: lodsb
        or      al, al
        jnz     .suflp
        ;; Point RDI to the null byte at end of dest
        xchg    rdi, rsi
        dec     rdi
        ;; Now copy RSI to RDI until we hit a zero
.cpylp: lodsb        
        stosb
        or      al, al
        jnz     .cpylp
        ;; Done.
        ret
        
two_fer:
        push    rbp
        mov     rbp, rsp
        push    r12
        push    r13
        ;; Stash arguments in callee-saved regs
        mov     r12, rdi        ; name
        mov     r13, rsi        ; buffer
        ;; If the first argument was NULL, make it "you"
        or      r12, r12
        jnz     .ok
        lea     r12, [def]
        ;; Reset destination buffer to empty
.ok:    mov     byte [r13], 0
        ;; Copy prologue to destination buffer
        mov     rdi, r13
        lea     rsi, [pre]
        call    mystrcat
        ;; Copy name to destination buffer
        mov     rdi, r13
        mov     rsi, r12
        call    mystrcat
        ;; Copy epilogue to destination buffer
        mov     rdi, r13
        lea     rsi, [post]
        call    mystrcat
        ;; Restore spilled registers and complete        
        pop     r13
        pop     r12
        pop     rbp
        ret

        section .rodata
pre:    db "One for ",0
def:    db "you",0
post:   db ", one for me.",0
