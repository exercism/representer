section .text
global largest_product
largest_product:
    xor eax, eax
    mov edx, edi
    mov r10, -2 ; for error handling
    xor r11, r11 ; for error handling
    cmp edx, 0
    sete al
    je .ret 
    cmovl rax, r10
    jl .ret
    mov rdi, rsi
    mov rcx, -1
    repne scasb
    not rcx
    dec rcx ; number of digits
    sub ecx, edx
    cmovl rax, r10
    jl .retminus
.loop_offset:
    cmp ecx, 0
    jl .ret
    mov edi, 1
    lea r8d, [ecx + edx]
.loop_multiply:
    cmp r8d, ecx
    je .loop_end
    movzx r9, byte [rsi + r8 - 1]
    sub r9b, '0'
    cmp r9b, 9
    cmova rax, r11
    ja .retminus
    imul rdi, r9
    dec r8d
    jmp .loop_multiply
.loop_end:
    cmp rdi, rax
    cmova rax, rdi
    dec ecx
    jmp .loop_offset
.retminus: ; for error handling
    dec rax
.ret: 
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
