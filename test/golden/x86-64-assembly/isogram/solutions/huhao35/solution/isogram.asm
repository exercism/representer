section .text
global is_isogram
is_isogram:
    ; Provide your implementation here
    ; The function has type signature int is_isogram(const char *str);
    ; The return value is of type int, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true
    ; The argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory
    push rbp
    mov rbp,rsp
    sub rsp,26
    mov rax,1
    .clear:
        mov rcx, rbp
        sub rcx, rax
        mov [rcx],0
        inc rax
        cmp rax,26
        jle .clear
        
    xor rax,rax
    .loop:
        mov al, [rdi]
        test al,al
        jz .succ
        cmp al,'A'
        jl .next
        cmp al,'z'
        jg .next
        
        cmp al,'a'
        jl .n
        sub al,'a' - 'A'
        
        .n:
        sub al, 'A'
        mov rcx, rbp
        sub rcx, rax
        dec rcx
        mov dl, [rcx]
        test dl,dl
        jnz .fail
        mov byte [rcx], 1
        .next:
        inc rdi
        jmp .loop
    .fail:
    mov rax,0
    jmp .end
    .succ:
    mov rax,1
    .end:
    mov rsp,rbp
    pop rbp
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
