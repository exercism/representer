section .text
global distance
distance:
    ; rsi and rdi are strings
    xor rax, rax
.compare_loop:
    ; see if rsi string is done
    mov dl, byte [rsi]
    test dl, dl
    jz .end_str

    ; see if rdi string is done
    mov dl, byte [rdi]
    test dl, dl
    jz .end_str

    ; zero out rbx which will be used to
    ; conditionally increment rax
    xor rbx, rbx
    ; compare *rdi to *rsi
    cmp dl, byte [rsi]
    ; rbx = 1 if not equal, 0 if equal
    setne bl
    add rax, rbx
    inc rsi
    inc rdi
    jmp .compare_loop
.end_str:
    ; when here, one of the strings has ended
    ; make sure that they have both ended (i.e., same length)
    mov bl, byte [rsi]
    cmp bl, byte [rdi]
    je .done
    mov rax, -1
.done:
    ret
