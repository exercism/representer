default rel

section .rodata
    ; TODO: use binary estimate
    x0: dq 2.0
    error: dq 0.1
    mask: dq -1 >> 1

section .text
global square_root
; rdi : n
square_root:
    movsd xmm0, [x0]
    movsd xmm1, [error]
    cvtsi2sd xmm2, edi
    movsd xmm6, [mask]
.loop:
    movsd xmm3, xmm0 ; xmm3 = X0
    mulsd xmm3, xmm0 ; xmm3 = X0^2
    movsd xmm4, xmm2 ; xmm4 = X
    subsd xmm4, xmm3 ; xmm4 = X - X0^2
    andpd xmm4, xmm6 ; xmm4 = |X - X0^2|
    comisd xmm4, xmm1
    jc .done
    movsd xmm5, xmm2 ; xmm5 = X
    addsd xmm5, xmm3 ; xmm5 = X + X0^2
    movsd xmm4, xmm0 ; xmm4 = X0
    addsd xmm4, xmm0 ; xmm4 = 2X0
    movsd xmm0, xmm5 ; xmm0 = 2X0
    divsd xmm0, xmm4 ; xmm0 = (X + X0^2) / 2X0
    jmp .loop
.done:
    cvtsd2si eax, xmm0

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
