default rel

section .rodata
    text1               db    "One for "    ; length = 8
    text2               db    ", one for me.", 0
    default_name        db    "you", 0

section .text
global two_fer
two_fer:
    mov rdx, rsi         ; save the address of the buffer in rdx
    mov rcx, [text1]     ; write "One for " in rcx
    mov [rdx], rcx       ; write "One for " at the beginning of the buffer
    add rdx, 8           ; rdx now points at the end of the string just written
    test rdi, rdi        ; check whether the input name is empty
    jnz name_given
    ; if no name is given
    mov ecx, [default_name]    ; write "you" in ecx
    mov [rdx], ecx             ; write "you" in the buffer
    add rdx, 3                 ; update the position in the buffer
    jmp last
name_given:              ; the string has at least length 1
    mov rax, rdi         ; save the address of the name to rax
    mov cl, byte [rax]   ; move the character pointed by rax to cl
loop:
    mov byte [rdx], cl   ; write the current character to the buffer
    inc rdx              ; increment the buffer pointer
    inc rax              ; increment the name character pointer
    mov cl, byte [rax]   ; move the character pointed by rax to cl
    cmp cl, 0            ; check whether the current character is zero
    jne loop             ; if not, restart the loop
last:
    mov rcx, [text2]       ; write the first 8 bytes of text2 to rcx
    mov [rdx], rcx         ; write them to the buffer
    mov rcx, [text2+8]     ; do the same for the remaining bytes
    mov [rdx+8], rcx
    ret
