section .text
global is_isogram
is_isogram:
    mov rsi, rdi
    xor edi, edi
    add edi, 1
    xor eax, eax
    xor ecx, ecx
    .loop:
        lodsb
        test al, al
        jz .fin
        cmp eax, 0x41
        jl .loop
        btr eax, 5
        sub eax, 0x41
        cmp eax, 26
        jae .loop
        bts ecx, eax
        jnc .loop
    xor edi, edi
    .fin:
    mov eax, edi
    ret