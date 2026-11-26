%include "debug.mac"
default rel
section .bss
    buffer resb 256
section .text
global ciphertext

ciphertext:
    mov r8, rdi              ; Save output pointer
    lea rdi, [buffer]        ; Set output pointer to buffer
    mov rax, "        "
    mov rcx, 256/8
    rep stosq
    lea rdi, [buffer]
.input_loop:
    lodsb                    ; Read character
    test al, al              ; Is null?
    je .input_end
    cmp al, '0'              ; Is digit?
    jb .input_loop
    cmp al, '9'
    jb .input_store
    or al, 0b00100000        ; Make lowercase
    cmp al, 'a'              ; Is letter?
    jb .input_loop
    cmp al, 'z'
    ja .input_loop
.input_store:
    stosb                    ; Write to buffer
    inc rcx                  ; Increase input length
    jmp .input_loop
.input_end:
    test rcx, rcx            ; Length 0?
    je .empty_string
    cvtsi2sd xmm0, rcx       ; Get square root of length
    sqrtsd xmm0, xmm0
    roundsd xmm0, xmm0, 0b10 ; Round up
    cvtsd2si rax, xmm0
    mov rdx, rax             ; Chunk count
    mov r9, rax
    dec r9
    imul rax, r9
    cmp rax, rcx
    cmovl r9, rdx            ; Chunk size
    mov rdi, r8
    xor r10, r10             ; Chunk index
.chunk_start:
    lea rsi, [buffer]
    add rsi, r10
    mov rcx, r9
.chunk_loop:
    mov al, byte [rsi]
    stosb
    add rsi, rdx
    loop .chunk_loop
    inc r10
    cmp r10, rdx
    je .end_string
    mov al, ' '
    stosb
    jmp .chunk_start
.end_string:
    mov r8, rdi
.empty_string:
    xor rax, rax
    mov byte [r8], al
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU+stack noalloc noexec nowrite progbits
%endif
