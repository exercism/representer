default rel
section .text
global color_code
color_code:
    mov r8, rdi
    xor r9, r9
    lea r10, [color_array]
    lea r11, [color_len]
    xor rcx, rcx
loop:
    mov rsi, [r10+r9*8]
    mov rdi, r8
    mov cl, byte [r11+r9]
    repe cmpsb
    je ret_code
    add r9, 1
    cmp r9, 9
    jg err_code
    jmp loop
ret_code:
    mov rax, r9
    ret
err_code:
    mov rax, -1
    ret


global colors
colors:
    lea rax, [color_array]
    ret

section .data
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
color_array: dq black, brown, red, orange, yellow, green, blue, violet, grey, white, 0
color_len: db 6, 6, 4, 7, 7, 6, 5, 7, 5, 6

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
