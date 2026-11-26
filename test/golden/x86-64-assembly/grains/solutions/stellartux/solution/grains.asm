section .text
global square
square:
    mov rcx, rdi
    dec rcx
    mov rax, 1
    shl rax, cl
    xor rdi, rdi
    cmp rcx, 64
    cmovae rax, rdi
    ret

global total
total:
    xor rax, rax
    not rax
    ret
