section .text
global distance
distance:
    xor rcx, rcx
.loop:
    mov al, [rdi]
    mov dl, [rsi]
    cmp al, dl    ;; compare strings at current position
    je .equal
    cmp al, 0     ;; if chars are not equal and one is 0
    je .error     ;; then the strings have different sizes
    cmp dl, 0
    je .error
    inc rcx       ;; increment counter
.equal:
    cmp al, 0     ;; if chars are equal and one is 0
    je .done      ;; then we are done
    inc rdi       ;; go to next char
    inc rsi
    jmp .loop
.error:
    mov rcx, -1
.done:
    mov rax, rcx
    ret