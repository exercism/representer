default rel

section .text align=16
global color_code
color_code:
    mov eax, -1
    test rdi, rdi
    jz .found  ; rdi is NULL

    lea r10, [all_colors]
    mov r11, rdi
    cld
    
.loop:
    inc eax
    mov rsi, [r10]
    test rsi, rsi
    jz .found  ; unknown color
    mov rdi, r11
    mov rcx, 2
    repe cmpsb
    je .found  ; match
    add r10, 8
    jmp .loop

.found:
    ret

global colors
colors:
    lea rax, [all_colors]
    ret

section .data align=8
    all_colors: dq black, brown, red, orange, yellow, green, blue, violet, grey, white, 0

section .rodata align=8
    black: db "black", 0
    brown: db "brown", 0
    red: db "red", 0
    orange: db "orange", 0
    yellow: db "yellow", 0
    green: db "green", 0
    blue: db "blue", 0
    violet: db "violet", 0
    grey: db "grey", 0
    white: db "white", 0

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
