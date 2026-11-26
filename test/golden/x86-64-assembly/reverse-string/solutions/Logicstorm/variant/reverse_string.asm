section .text
global reverse
reverse:
    mov rsi, rdi
    xor rcx, rcx
    xor al, al
    scasb
    jne .read_loop
    ret

.read_loop:
    inc rcx
    scasb
    jne .read_loop

    xchg rdi, rsi
    dec rsi
    shr rcx, 2
    jz .nothing_to_do

.copy_loop:
    dec rsi
    mov al, [rdi]
    xchg al, [rsi]
    stosb
    dec rcx
    jnz .copy_loop

.nothing_to_do:
    ret
