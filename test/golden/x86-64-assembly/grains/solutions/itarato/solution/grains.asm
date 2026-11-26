section .text
global square
square:
    xor rax, rax
    cmp rdi, 0x1
    jl .square_done
    cmp rdi, 0x40
    jg .square_done
    mov rax, 0x1
    mov rcx, rdi
    dec cl
    shl rax, cl
.square_done:
    ret

global total
total:
    xor rax, rax
    dec rax
    ret
