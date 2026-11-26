section .text
global nucleotide_counts
; extern void nucleotide_counts(const char* strand, int64_t* counts);
nucleotide_counts:
    xor rbx, rbx
    mov [rsi], rbx
    mov [rsi+8], rbx
    mov [rsi+16], rbx
    mov [rsi+24], rbx
_start:
    mov al, byte [rdi]
    cmp al, 0
    je _end
    cmp al, 'A'
    je _A
    cmp al, 'G'
    je _G
    cmp al, 'T'
    je _T
    cmp al, 'C'
    je _C
    mov rax, -1
    mov [rsi], rax
    mov [rsi+8], rax
    mov [rsi+16], rax
    mov [rsi+24], rax
    ret
_A:
    inc qword [rsi]
    inc rdi
    jmp _start
_C:
    inc qword [rsi+8]
    inc rdi
    jmp _start
_G:
    inc qword [rsi+16]
    inc rdi
    jmp _start
_T:
    inc qword [rsi+24]
    inc rdi
    jmp _start
_end:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
