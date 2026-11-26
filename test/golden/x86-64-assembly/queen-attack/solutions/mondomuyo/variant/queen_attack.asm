default rel

section .text
global distance

global can_create
can_create:
    cmp rdi, 0
    jl .no

    cmp rdi, 7
    jg .no

    cmp rsi, 0
    jl .no

    cmp rsi, 7
    jg .no

    mov rax, 1
    ret
.no:
    mov rax, 0
    ret

abs_:
    cmp rax, 0
    jge .ret
    neg rax
.ret:
    ret


global can_attack
can_attack:
    cmp rdi, rdx
    je .yes

    cmp rsi, rcx
    je .yes

    mov rax, rdi
    sub rax, rdx
    call abs_
    mov rdi, rax

    mov rax, rsi
    sub rax, rcx
    call abs_
    mov rsi, rax

    cmp rdi, rsi
    jne .no
    jmp .yes

.yes:
    mov rax, 1
    ret
.no:
    mov rax, 0
    ret


%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
