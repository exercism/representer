section .text
global to_rna
to_rna:
    mov dl, byte[rdi]
    cmp dl, 0
    je end
    cmp dl, 'G'
    je G
    cmp dl, 'C'
    je C
    cmp dl, 'T'
    je T
    cmp dl, 'A'
    je A
    mov byte[rsi], dl
    jmp read_next
G:
    mov byte[rsi], 'C'
    jmp read_next
C:
    mov byte[rsi], 'G'
    jmp read_next
T:
    mov byte[rsi], 'A'
    jmp read_next
A:
    mov byte[rsi], 'U'
    jmp read_next
read_next:
    inc rsi
    inc rdi
    jmp to_rna
end:
    mov byte[rsi], 0
    ret
