section .text
global steps
steps:
    ; Provide your implementation here
    ; arg in rdi
    mov rax, rdi
    mov rcx, -1

    cmp rdi, 0
    je .error

    cmp rdi, 0xFFFFFFF
    ja .error
    inc rcx
    
.check:
    cmp rax, 1
    je .return
    
    
    inc rcx

    test rax, 1
    jnz .muladd
 
    shr rax, 1
    jmp .check
    

.muladd:
    lea rax, [rax*2 + rax + 1]
    jmp .check

.return:
    mov rax, rcx
    ret

.error:
    mov rax, -1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
