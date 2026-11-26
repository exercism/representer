section .text
global square
square:
    xor rax, rax
    mov cl, dil
    dec cl
    test cl, 0xC0
    jnz .end
    inc rax
    shl rax, cl
  .end:
    ret

global total
total:
    xor rax, rax
    not rax
    ret

