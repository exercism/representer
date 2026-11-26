section .text
global to_rna
to_rna:
    ; Provide your implementation here
    ; The function has type signature void to_rna(const char *strand, char *buffer)
    ; It has no return value
    ; The first argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory
    ; The second argument is of type char*, which is the address of a writable sequence of bytes stored in memory
    xor ax,ax
    .loop:
        mov al,byte [rdi]
        test al,al
        jz .r
        cmp al,'G'
        je .c
        cmp al,'C'
        je .g
        cmp al,'T'
        je .a
        jmp .u
        .c:
        mov ah,'C'
        jmp .end
        .g:
        mov ah,'G'
        jmp .end
        .a:
        mov ah,'A'
        jmp .end
        .u:
        mov ah,'U'
        .end:
        mov [rsi],ah
        inc rdi
        inc rsi
        jmp .loop
    .r:
    mov byte [rsi],0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
