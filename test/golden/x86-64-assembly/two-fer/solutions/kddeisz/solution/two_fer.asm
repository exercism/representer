; void two_fer(const char *name, char *buffer);
;                           |            |
;                           |-> rdi      |-> rsi

section .text
global two_fer

two_fer:
    mov rax, rsi                ; move the buffer argument into rax
    mov rcx, [rel prefix]       ; move the address of the pre string into rcx
    mov [rax], rcx              ; move the pre string into the pointer address stored in rax
    add rax, prelen             ; move the buffer pointer forward by the length of the pre string
    test rdi, rdi               ; bitwise and the name pointer to see if it was passed
    jz default_name             ; jump to the default_name label if the name was not passed

copy_name:
    mov cl, byte [rdi]          ; copy one byte from the name pointer stored in rdi
    test cl, cl                 ; bitwise and the name pointer to see if we've hit a terminator
    jz remainder                ; if we're at the end of the name, jump to the remainder label
    mov [rax], byte cl          ; otherwise, move the byte we just stored into the pointer at rax
    inc rax                     ; increment the buffer pointer so we're pointing at the next slot
    inc rdi                     ; increment the name pointer so we're pointing at the next slot
    jmp copy_name               ; jump back to the copy_name label to get the next char

default_name:
    mov ecx, [rel defnme]       ; copy the you string pointer into the ecx register
    mov [rax], ecx              ; copy the string pointer into the address of the rax register
    add rax, deflen             ; add the string length of the default name to the rax register

remainder:
    mov rcx, [rel pstfix]       ; move the address of the post string into the rcx register
    mov [rax], rcx              ; move the first 8 bytes of the post string into the rax register
    add rax, 8                  ; increment the rax register by 8 bytes
    mov rcx, [rel pstfix + 8]   ; move the next 8 bytes of the post string into the rcx register
    mov [rax], rcx              ; move the value in rcx into the pointer in the rax register
    ret

section .rodata

prefix  db "One for ", 0
prelen  equ $-prefix - 1
defnme  db "you", 0
deflen  equ $-defnme - 1
pstfix  db ", one for me.", 0
