section .text
global to_rna
to_rna:
    ; Provide your implementation here
    mov rcx, -1 ; the char counter will increment on each loop iteration
loop:
    inc rcx ; move string pointer along
    mov al, [rdi + rcx] ; read next character
    cmp al, 0
    je done

    cmp al, "A"
    je put_U
    cmp al, "T"
    je put_A
    cmp al, "G"
    je put_C
    cmp al, "C"
    je put_G

put_A:
    mov byte [rsi + rcx], "A"
    jmp loop
put_U:
    mov byte [rsi + rcx], "U"
    jmp loop
put_C:
    mov byte [rsi + rcx], "C"
    jmp loop
put_G:
    mov byte [rsi + rcx], "G"
    jmp loop

done:
    mov byte [rsi + rcx], 0 ; terminate string
    ret
