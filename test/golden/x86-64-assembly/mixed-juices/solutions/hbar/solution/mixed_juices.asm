section .rodata
juice_time db 1, 3, 3, 4, 5, 4, 7, 10

section .text

global time_to_make_juice
time_to_make_juice:
    ; This function has one argument, the ID for a juice as a 32-bit number
    ; It returns the time to prepare this juice, as a 32-bit number
    ; Doesn't use stack, only modifies r9
    lea r9, [rel juice_time]
    movzx eax, byte [r9 + rdi - 1]
    ret

global time_to_prepare
time_to_prepare:
    ; This function has two arguments:
    ; - An array with the IDs for ordered juices, each ID a 32-bit number
    ; - The number of ordered juices, also a 32-bit number.
    ; It returns the total time to prepare all ordered juices, as a 32-bit number
    mov r8, rdi
    xor edx, edx
.loop:
    test esi, esi
    jz .ret
    mov edi, [r8]
    call time_to_make_juice
    add edx, eax
    add r8, 4
    dec esi
    jmp .loop
.ret:
    mov rax, rdx
    ret

global limes_to_cut
limes_to_cut:
    ; This function takes three arguments:
    ; - The number of wedges needed.
    ; - An array with the current supply of limes, each represented by a 8-bit number.
    ; - The number of limes in the supply, as a 32-bit number.
    ; It returns the number of limes that need to be cut, as a 32-bit number
    xor eax, eax
    xor r8d, r8d
.loop:
    cmp eax, edx
    je .ret
    cmp edi, r8d
    jbe .ret
    sub edi, r8d
    mov cl, [rsi + rax]
    inc eax
    mov r8b, 6
    cmp cl, 'S'
    je .loop
    add r8b, 2
    cmp cl, 'M'
    je .loop
    add r8b, 2
    jmp .loop
.ret:
    ret

global remaining_orders
remaining_orders:
    ; This function takes two arguments:
    ; - The time left in the shift.
    ; - An array  with the IDs for ordered juices still not prepared, each ID a 32-bit number.
    ; It returns the number of juices made before the shift ends, as a 32-bit number.
    ; You may consider that:
    ; - The array is never empty.
    ; - The time left in the shift at the beginning is always greater than 0.
    ; - There are more orders in the array than that which can be prepared before the shift ends.
    mov ecx, edi
    xor edx, edx
.loop:
    mov edi, [rsi + 4 * rdx]
    inc edx
    call time_to_make_juice  
    sub ecx, eax
    ja .loop
.ret:
    mov eax, edx 
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
