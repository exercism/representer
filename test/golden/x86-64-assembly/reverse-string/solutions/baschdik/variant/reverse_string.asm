section .text
global reverse
reverse:
    mov rsi, rdi
_push:
    cmp byte [rsi], 0
    je _pop    
    mov al, byte [rsi]
    push rax
    inc rsi
    jmp _push
_pop:
    cmp byte [rdi], 1
    je _fini
    pop rax 
    mov byte [rdi], al
    inc rdi
    jmp _pop    
_fini:    
    ret
