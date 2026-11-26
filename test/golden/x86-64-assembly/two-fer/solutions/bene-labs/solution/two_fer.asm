default rel

section .rodata ; read-only data can go in the .rodata section on GNU/Linux, like .rdata on Windows
pre_name: db "One for ",0
;len_pre_name: equ $-pre_name
default_name: db "you",0
;len_default_name: equ $-default_name
after_name: db ", one for me.", 0
;len_after_name: equ $-after_name

section .text

global two_fer
two_fer:
    mov r10, rsi
    xor rcx, rcx ; Loop Counter
    lea r12, [pre_name] ; Store static pre-name string as local variable

.ADD_PRE_NAME_LOOP:
    mov bl, BYTE [r12+rcx]
    mov BYTE[r10+rcx], bl
    cmp bl, 0
    je .SETUP_SET_NAME_LOOP
    inc rcx
    jmp .ADD_PRE_NAME_LOOP
    
.SETUP_SET_NAME_LOOP:
    add r10, rcx
    xor rcx, rcx
    cmp rdi, 0 ; check if source string index is 0 => null pointer
    je .ON_EMPTY_NAME
    mov al, BYTE [rdi] ; store byte at source (name) string index in al
    cmp al, 0 ; check if start of source string is '\0' meaning an empty string was passed
    je .ON_EMPTY_NAME
    jmp .SET_NAME_LOOP

.ON_EMPTY_NAME:
    lea rdi, [default_name]

.SET_NAME_LOOP:
    mov bl, BYTE [rdi+rcx] ; store char from name[rcx] in 8-bit base register bl
    mov BYTE[r10+rcx], bl ; move name char to dest string after pre-name text
    cmp bl, 0 ; was end of string reached?
    je .SETUP_AFER_NAME_LOOP
    inc rcx ; rcx++
    jmp .SET_NAME_LOOP

.SETUP_AFER_NAME_LOOP:
    add r10, rcx
    xor rcx, rcx
    lea r12, [after_name]

.ADD_AFTER_NAME_LOOP:
    mov bl, BYTE [r12+rcx]
    mov BYTE[r10+rcx], bl
    cmp bl, 0
    je .EXIT
    inc rcx
    jmp .ADD_AFTER_NAME_LOOP

.EXIT:
    ret