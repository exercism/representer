section .text
global square
square:
    ; n = rdi
    ; x = 2 ** (n-1)
    movsx rdi, edi
    cmp   rdi, 0
    jle   .return_zero
    mov   rax, rdi
    cmp   rdi, 2
    jle   .end
    mov   rax, 2

.loop:
    dec   rdi
    imul  rax, 2
    cmp   rdi, 2
    jne   .loop

.end:
    ret

.return_zero:
    mov rax, 0
    ret

global total
total:
    ; x = (2 ** 64) - 1
    mov  r8, 64
    mov  rax, 2

    loop2:
    imul rax, 2
    dec  r8
    cmp  r8, 0
    jne  loop2

    dec  rax
    ret
