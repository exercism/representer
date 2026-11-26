default rel

section .rodata
s0 db " green bottles", 0
s1 db " hanging on the wall,", 0xA, 0
s2 db "And if one green bottle should accidentally fall,", 0xA, 0
s3 db "There'll be ", 0
newline db 0xA, 0
n0 db "no", 0
n1 db "one", 0
n2 db "two", 0
n3 db "three", 0
n4 db "four", 0
n5 db "five", 0
n6 db "six", 0
n7 db "seven", 0
n8 db "eight", 0
n9 db "nine", 0
n10 db "ten", 0

section .data
nums dq n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10

section .text
global recite
recite:
    ; parameters rdi, esi, edx
    mov ecx, edx
    mov edx, esi
    lea r8, [rel nums]
.loop:
    test ecx, ecx
    jbe .ret
    mov rsi, [r8 + 8 * rdx]
    mov ah, 0xDF
    call print
    lea rsi, [rel s0]
    call print
    cmp edx, 1
    jne .mid0
    dec rdi ; remove s
    mov byte [rdi], 0
.mid0:
    lea rsi, [rel s1]
    call print
    mov rsi, [r8 + 8 * rdx]
    mov ah, 0xDF
    call print
    lea rsi, [rel s0]
    call print
    cmp edx, 1
    jne .mid1
    dec rdi ; remove s
    mov byte [rdi], 0
.mid1:
    lea rsi, [rel s1]
    call print
    lea rsi, [rel s2]
    call print
    lea rsi, [rel s3]
    call print
    dec edx ; decrement the number of bottles
    mov rsi, [r8 + 8 * rdx] 
    call print
    lea rsi, [rel s0]
    call print
    cmp edx, 1
    jne .mid2
    dec rdi ; remove s
    mov byte [rdi], 0
.mid2:
    lea rsi, [rel s1]
    call print
    mov byte [rdi - 2], '.'
    dec ecx
    jz .ret 
    lea rsi, [rel newline]
    call print
    jmp .loop
.ret:
    ret

print:
    ; parameters: rdi, rsi, ah
    ; uses: rax
.loop:
    lodsb
    and al, ah
    mov ah, 0xFF
    stosb
    test al, al
    jnz .loop
    dec rdi
    ret

    



%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
