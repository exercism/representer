default rel

section .rodata
    black   db "black", 0
    brown   db "brown", 0
    red     db "red", 0
    orange  db "orange", 0
    yellow  db "yellow", 0
    green   db "green", 0
    blue    db "blue", 0
    violet  db "violet", 0
    grey    db "grey", 0
    white   db "white", 0

section .data
    colours dq black, brown, red, orange, yellow, green, blue, violet, grey, white, 0

section .text
    global color_code

color_code:
    mov r9, rdi ; backup rdi
    lea rdx, [colours]
    mov r8, 0 ; i = 0

L1:
    mov rdi, r9 ; restore rdi
    lea rsi, [rdx + r8 * 8] ; rsi = colours[i]
    mov rsi, qword[rsi]

    cld
    mov rcx,  5
    repe cmpsb ; compare  rdi and rsi
    je L_EXIT ; if rdi == rsi  then exit

    inc r8 ; i++
    jmp L1

L_EXIT:
    mov rax, r8
    ret

global colors
colors:
    lea rax, [colours]
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
