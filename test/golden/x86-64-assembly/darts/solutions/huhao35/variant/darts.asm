section .text
global score
score:
    ; Provide your implementation here
    ; The function has type signature uint8_t score(double x, double y)
    ; The return value is of type uint8_t, which is a 8-bit unsigned integer
    ; Both arguments are of type double, which is a 64-bit floating-point
    mulsd xmm0,xmm0
    mulsd xmm1,xmm1
    addsd xmm0,xmm1
    mov rax,100
    cvtsi2sd xmm1,rax
    comisd xmm0,xmm1
    jna .n1
    mov rax,0
    ret
    .n1:
    mov rax,25
    cvtsi2sd xmm1,rax
    comisd xmm0,xmm1
    jna .n2
    mov rax,1
    ret
    .n2:
    mov rax,1
    cvtsi2sd xmm1,rax
    comisd xmm0,xmm1
    jna .n3
    mov rax,5
    ret
    .n3:
    mov rax,10
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
