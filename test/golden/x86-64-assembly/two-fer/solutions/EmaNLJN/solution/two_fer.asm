section .text
global two_fer

; rdi -> *name
; rsi -> *buffer
two_fer:
    ; Provide your implementation here
    push rbp
    mov rbp, rsp

    mov [rsi], dword 'One'
    add rsi, 3

    mov [rsi], dword ' '
    add rsi, 1

    mov [rsi], dword 'for'
    add rsi, 3

    add [rsi], dword ' '
    add rsi, 1

    cmp rdi, 0
    je else

    xor rcx, rcx

bucle:
    cmp byte [rdi + rcx], 0
    je salir
    mov al, byte [rdi + rcx]
    mov byte [rsi + rcx], al
    inc rcx
    jmp bucle

salir:
    add rsi, rcx
    jmp endif
else:
    mov [rsi], dword 'you'
    add rsi, 3
endif:

    mov [rsi], dword ', '
    add rsi, 2

    mov [rsi], dword 'one'
    add rsi, 3

    mov [rsi], dword ' '
    add rsi, 1

    mov [rsi], dword 'for'
    add rsi, 3

    mov [rsi], dword ' '
    add rsi, 1

    mov [rsi], dword 'me.'
    add rsi, 3

    pop rbp
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
