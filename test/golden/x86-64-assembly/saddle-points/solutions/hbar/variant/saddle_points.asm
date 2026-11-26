section .text

global saddle_points

saddle_points:
    mov r11, rsp
    xor eax, eax
    test rdx, rdx
    jz .ret
    mov rcx, rdx
    mov rax, 0x8000000000000000
.stack_row:
    push rax
    loop .stack_row
    dec rax
    mov ecx, 15
.stack_col:
    push rax
    loop .stack_col
    mov r8, rsi
    mov r9, rdx
    xor eax, eax
.loop_max_min:
    xor rcx, rcx
.loop_max_min_row:
    cmp rcx, [rsi]
    je .loop_max_min_end
    mov r10, [rsi + rcx * 8 + 8] 
    cmp r10, [rsp + rcx * 8]
    jnl .loop_max_min_row_min
    mov [rsp + rcx * 8], r10
.loop_max_min_row_min:
    cmp r10, [rsp + rdx * 8 + 112]
    jng .loop_max_min_row_end
    mov [rsp + rdx * 8 + 112], r10
.loop_max_min_row_end:
    inc rcx
    jmp .loop_max_min_row
.loop_max_min_end:
    add rsi, 128
    dec rdx
    jnz .loop_max_min
    mov rsi, r8
    mov rdx, r9
.loop_saddle:
    xor rcx, rcx
.loop_saddle_row:
    cmp rcx, [rsi]
    je .loop_saddle_end
    mov r10, [rsi + rcx * 8 + 8] 
    cmp r10, [rsp - rcx * 8]
    jne .loop_saddle_row_end
    cmp r10, [rsp + rdx * 8 + 112]
    jne .loop_saddle_row_end
    inc rax
    lea r10, [r9 + 1]
    sub r10, rdx
    mov [rdi], r10
    lea r10, [rcx + 1]
    mov [rdi + 8], r10
    add rdi, 16
.loop_saddle_row_end:
    inc rcx
    jmp .loop_saddle_row
.loop_saddle_end:
    add rsi, 128
    dec rdx
    jnz .loop_saddle
.ret:
    mov rsp, r11
    ret


%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
