section .text
global square
square:
    ; uint64_t square(int64_t number);
    ; rdi = number
    
    ;; error handling
    cmp rdi, 0 ; <= 0
    jle .error
    cmp rdi, 64 ; > 64
    jg .error


    mov cl, dil
    dec cl
    mov rax, 1
    shl rax, cl
    ret
.error:
    xor rax, rax
    ret

global total
total:
    ; uint64_t total(void);
    xor rcx, rcx ; loop count
    xor rbx, rbx ; accumulate
.loop:
    inc rcx
    cmp rcx, 64
    jg .done

    mov rdi, rcx
    push rcx
    push rbx
    call square
    pop rbx
    pop rcx
    add rbx, rax ; accumulator += square(rcx)
    jmp .loop
.done:
    mov rax, rbx
    ret
