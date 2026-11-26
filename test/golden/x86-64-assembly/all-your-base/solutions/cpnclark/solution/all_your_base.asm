section .text
global rebase

rebase:
    ;const int32_t* in_digits, int32_t digits_count, int32_t in_base, int32_t* out_array, int32_t out_base);
    ; %rdi in_digits 
    ; %esi digits_count
    ; %edx in_base
    ; %rcx out_array
    ; %r8d  out_base
    ; Provide your implementation here
    cmp edx, 2
    jl bad_input_base
    cmp r8d, 2
    jl bad_input_base
    jmp continue

bad_input_base:
    mov eax, -1
    ret

bad_digit:
    mov rbx, r11
    mov rax, -2
    ret

continue:
    mov  r11, rbx   ; save rbx
    xchg rsi, rcx  ; rsi <- out_array, ecx <- digits_count
    mov r9, rdx    ; r9b <- in_base
    xchg rdi, rsi  ; rdi <- out_array, rsi <- in_digits
    mov r10, rdi   ; r10 <- out_array

read_N:
    ; rsi: digits
    ; cl: digits_count
    ; r9: base
    ; answer in eax
    xor ebx, ebx
.loop:
    test cl, cl
    jz .done
    lodsd
    cmp eax, r9d
    jae bad_digit
    xchg eax, ebx
    mul r9w
    add ebx, eax
    dec cl
    jmp .loop
.done:
    mov eax, ebx

write_base:
    ; eax: N
    ; rdi: out_digits
    ; r8: b (base)
    mov rcx, rsp
.loop:             ; push digits least-sig first on stack
    xor edx, edx
    div r8d ; eax <- N / b, edx <- N % b
    push rdx
    test eax, eax
    jne .loop

    sub rcx, rsp    ; calculate length
    shr rcx, 3
    mov rdx, rcx

.write_loop:
    pop rax         ; pop from stack and write to output
    stosd
    loop .write_loop
    mov rbx, r11         ; restore rbx
    mov eax, edx        ; rax <- out_count

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
