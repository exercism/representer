default rel

section .rodata
    msg1 db ", you are the "
    msg1_len equ $-msg1
    msg3 db " customer we serve today. Thank you!", 0
    msg3_len equ $-msg3

section .text
global format

; void format(char *buffer, const char *name, uint16_t number)
;             rdi,          rsi,              rdx
format:
    mov r9, rdx             ; save rdx
    cld
.string_loop:
    lodsb
    test al, al
    jz .name_done
    stosb
    jmp .string_loop 
.name_done:
    lea rsi, [msg1]
    mov rcx, msg1_len
.message_loop:
    lodsb
    stosb
    loop .message_loop
.message_done:
    mov rax, rdx
    mov r8, 10
    mov rcx, 0
.divide_loop:
    mov rdx, 0
    div r8
    push rdx
    inc rcx
    cmp rax, 0
    jne .divide_loop
.pop_loop:
    pop rax,
    add al, "0"
    stosb
    loop .pop_loop
    mov r10b, al    ; last digit
    mov rax, r9
    mov rdx, 0
    mov r8, 100
    div r8
    cmp rdx, 11
    je .th
    cmp rdx, 12
    je .th
    cmp rdx, 13
    je .th
    mov rdx, r9
    mov rdx, 0
    mov r8, 10
    div r8
    cmp r10b, "1"
    je .st
    cmp r10b, "2"
    je .nd
    cmp r10b, "3"
    je .rd
    jmp .th
.st:
    mov al, "s"
    stosb
    mov al, "t"
    stosb
    jmp .number_done
.nd:
    mov al, "n"
    stosb
    mov al, "d"
    stosb
    jmp .number_done
.rd:
    mov al, "r"
    stosb
    mov al, "d"
    stosb
    jmp .number_done
.th:
    mov al, "t"
    stosb
    mov al, "h"
    stosb
.number_done:
    lea rsi, [msg3]
    mov rcx, msg3_len
.message_loop2:
    lodsb
    stosb
    loop .message_loop2

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
