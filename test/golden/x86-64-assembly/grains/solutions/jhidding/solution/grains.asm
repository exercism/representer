section .text
global square

square:
    test rdi, rdi		; if lower than 1
    jng error
    cmp rdi, 64			; or larger than 64
    ja error			;    => error code

    mov rax, 1			; first square
    mov cx, di			; shift-left operand should be cl
    dec cx
    shl rax, cl
    ret

error:
    mov rax, 0
    ret

global total
total:
    xor rax, rax		; set rax to 0
    not rax                     ; 2^65 - 1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
