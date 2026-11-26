NEGATIVE_TARGET equ -1
UNREACHABLE_TARGET equ -2

section .text
global find_fewest_coins

find_fewest_coins:
    ; Arguments:
    ; rdi: result buffer (uint64_t*)
    ; rsi: coins array (uint64_t*)
    ; rdx: coins count (size_t)
    ; rcx: target value (int64_t)

    ; 1. Early exits for edge cases
    cmp rcx, 0
    jl .return_negative
    je .return_zero

    ; 2. Prologue - Setup stack frame and preserve callee-saved registers
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    ; Move arguments to preserved registers
    mov r12, rdi      ; result buffer
    mov r13, rsi      ; coins array
    mov r14, rdx      ; coins count
    mov r15, rcx      ; target value

    ; 3. Memory Allocation for DP tables
    ; We need two arrays: min_coins[target+1] and first_coin[target+1]
    ; Total size: (target + 1) * 8 * 2
    mov rax, r15
    inc rax
    shl rax, 4        ; rax = (target + 1) * 16
    
    ; Align stack and allocate
    add rax, 15
    and rax, -16
    sub rsp, rax

    ; Set table pointers
    mov rbx, rsp      ; rbx = min_coins table
    mov rax, r15
    inc rax
    shl rax, 3
    lea r11, [rbx + rax] ; r11 = first_coin table

    ; 4. Initialize DP tables
    ; Fill both tables with INF (0x7FFFFFFFFFFFFFFF)
    mov r10, 0x7FFFFFFFFFFFFFFF
    mov rdi, rbx
    mov rax, r10
    mov rcx, r15
    inc rcx
    shl rcx, 1        ; Number of qwords across both tables
    cld
    rep stosq
    
    ; Set base case: min_coins[0] = 0
    mov qword [rbx], 0

    ; 5. DP Main Loop
    mov rcx, 1        ; current_amt (i)
.outer_loop:
    cmp rcx, r15
    jg .dp_done

    xor rsi, rsi      ; coin index (j)
.inner_loop:
    cmp rsi, r14
    jge .outer_next

    mov rax, [r13 + rsi*8] ; coin_val
    cmp rax, rcx
    jg .inner_next         ; coin too large

    ; prev_count = min_coins[current_amt - coin_val]
    mov r8, rcx
    sub r8, rax
    mov r9, [rbx + r8*8]
    
    mov r10, 0x7FFFFFFFFFFFFFFF
    cmp r9, r10
    je .inner_next         ; previous amount unreachable

    inc r9                 ; new_count = prev_count + 1
    cmp r9, [rbx + rcx*8]  ; compare with current best
    jge .inner_next

    ; Update optimal values
    mov [rbx + rcx*8], r9
    mov [r11 + rcx*8], rax ; store coin used

.inner_next:
    inc rsi
    jmp .inner_loop

.outer_next:
    inc rcx
    jmp .outer_loop

.dp_done:
    ; 6. Result Validation
    mov rax, [rbx + r15*8]
    mov r10, 0x7FFFFFFFFFFFFFFF
    cmp rax, r10
    je .unreachable

    ; 7. Solution Reconstruction
    ; rax contains total count
    mov r10, rax      ; save final count for return
    xor rcx, rcx      ; write index
    mov r8, r15       ; remaining amount
.reconstruct:
    test r8, r8
    jz .sort_results
    mov r9, [r11 + r8*8] ; get used coin
    mov [r12 + rcx*8], r9
    sub r8, r9
    inc rcx
    jmp .reconstruct

.sort_results:
    ; Bubble Sort the output buffer
    cmp r10, 2
    jl .success
    
    xor rsi, rsi      ; i
.sort_outer:
    mov rax, r10
    dec rax
    cmp rsi, rax
    jge .success
    
    xor rdi, rdi      ; j
.sort_inner:
    mov rax, r10
    dec rax
    sub rax, rsi      ; limit = count - 1 - i
    cmp rdi, rax
    jge .sort_outer_next
    
    mov rax, [r12 + rdi*8]
    mov rdx, [r12 + rdi*8 + 8]
    cmp rax, rdx
    jle .sort_inner_next
    
    ; Swap
    mov [r12 + rdi*8], rdx
    mov [r12 + rdi*8 + 8], rax
    
.sort_inner_next:
    inc rdi
    jmp .sort_inner
.sort_outer_next:
    inc rsi
    jmp .sort_outer

.success:
    mov rax, r10
    jmp .cleanup

.unreachable:
    mov rax, UNREACHABLE_TARGET
    jmp .cleanup

.return_negative:
    mov rax, NEGATIVE_TARGET
    ret

.return_zero:
    xor rax, rax
    ret

.cleanup:
    ; Restore RSP to the start of preserved registers block
    lea rsp, [rbp - 40]
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif