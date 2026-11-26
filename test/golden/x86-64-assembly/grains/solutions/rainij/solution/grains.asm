    section .text

    global square
square:
    ;; rdi contains n. We have to calculate 2**(n-1).
    xor     rax, rax            ; 0 means "invalid input"
    ;; Treat invalid inputs
    cmp     rdi, 1
    jl      .done
    cmp     rdi, 64
    jg      .done
    ;; Treat the general case
    mov     rax, 1
    mov     cl, dil
    dec     cl
    shl     rax, cl            ; cool second arg can be 1byte cl register!

    .done:
    ret


global total
total:
    mov     rax, -1             ; 2**64 - 1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
